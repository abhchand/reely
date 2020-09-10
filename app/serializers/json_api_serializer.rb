# Serializes a single record or a collection of records into the JsonAPI format
# See: https://jsonapi.org/
#
# # Overview
#
# We use the JsonApi standard to format all communication about models
# between client and server.
#
# From the perspective of the server, there's 2 cases where we serialize
# records -
#
#   1. When formatting an API response
#   2. When rendering Rails views and we need to serialize models as JSOn to
#      pass them to the frontend. (See note about Denormalization below)
#
# # JsonApi structure
#
# See the above site above for the latest specification and an example of what
# a full response looks like.
#
# But at a sketch of the structure might look like this for an `Article` that
# has many `Comment`s and belongs to an `Author`:
#
# ```
# {
#   "links": { ... },
#
#   // `data` will be [...] in the case of multiple records
#   "data": {
#     "id": "99",
#     "type": "article",
#     "attributes": {...},
#     "relationships": {
#       "author": {
#         "links": {...},
#         "data": { "id": "13", "type": "user" }
#       },
#       "comments": {
#         "links": {...},
#         "data": [
#           { "id": "1", "type": "comment" },
#           { "id": "7", "type": "comment" }
#         ]
#       }
#     }
#   },
#   "included": [
#     {
#       "id": "1",
#       "type": "comment",
#       "attributes": {...},
#       "links": {...}
#     },
#     ...
#   ]
# }
# ```
#
# # How it works
#
# We make use of the `fast_jsonapi` gem to quickly serialize any model. Each
# model has an associated serializer under `app/serializers/*` that define
# how to serialize that model and what objects to return.
#
# This class serves as a glorified wrapper that calls the appropriate serializer
# for a given record or collection of records.
#
# This class tries its best to "guess" the serializer for a given record or
# collection of records. So if you pass in a `@user` it will try to use the
# `UserSerializer`. This can be overridden with the `:serializer_name` option.
#
# # Denormalization
#
# When rendering views and passing serialized models to the front end, it can
# be more convenient to return the `data` sub-key directly instead of the entire
# response with metadata (which would include `links`, `included`, etc...).
#
# This also avoids us having to do things like `article.data` in the frontend
# to get the true data, and is consistent with the idea that the model should
# represent the _data_, not the metadata.
#
# However there is one problem: The `relationships` key defines all the all the
# associations this record might have. The JsonApi does not render the full
# relationship details, it just renders the `id` and `type` for each one as
# shown above. Instead, the full details for an associated record like `Comment`
# or `Author` are listed under the `included` key separate.
#
# This normalization of the data is done on purpose to compress the information
# and avoid duplication. But when we return the `data` key we lose detailed
# information listed under `included`.
#
# For this reason this class provides the option to _denormalize_ any
# associations and include the full attributes and information about an
# association direclty in the main data response. See `:denormalize` option.
#
# # Examples
#
#   # Serialize all records for a model
#   JsonApiSerializer.serialize(User)
#
#   # Serialize a single record
#   JsonApiSerializer.serialize(@user)
#
#   # Serialize an array of records
#   JsonApiSerializer.serialize([@user1, @user2])
#
#   # Serialize a collection of records
#   JsonApiSerializer.serialize(User.where(foo: "bar"))
#
# # Options
#
#   :serializer_name - Override the serializer to use. By default this service
#                      will try to "guess" what serializer to use.
#   :serializer_opts - Options to pass to the serializer itself, outlined in the
#                      `fastjson_api` gem documentation
#   :denormalize -     Boolean indicating whether the included associations
#                      should be denormalized. See background on this above.
#                      This option requires that we include associations in the
#                      first place (otherwise there's nothing to denormalize).
#                      This can be done via passing `{ includes: %i[comments] }`
#                      as options to the serializer via `:serializer_opts`

class JsonApiSerializer
  def self.serialize(data, opts = {})
    new(data, opts).serialize
  end

  def initialize(data, opts = {})
    @opts = opts.dup

    case
    when data.is_a?(Class)
      @dataset = data.order(:id)
      serializer = "#{data}Serializer"
    when data.is_a?(Array)
      @dataset = data
      serializer = "#{data.first.class}Serializer"
      raise "Unknown model class, specify `:serializer_name`" if data.empty?
    when data.is_a?(ActiveRecord::Relation)
      @dataset = data
      serializer = "#{data.model}Serializer"
    when data.is_a?(ActiveRecord::Base)
      @dataset = data
      serializer = "#{data.class}Serializer"
    end

    @serializer = @opts[:serializer_name] || serializer.constantize
  end

  def serialize
    json = @serializer.new(
      @dataset,
      @opts[:serializer_opts] || {}
    ).serializable_hash

    denormalize_includes!(json) if denormalize_includes?
    json
  end

  private

  def single_record?
    @dataset.is_a?(ActiveRecord::Base)
  end

  def denormalize_includes?
    @opts[:denormalize] &&
      @opts[:serializer_opts].is_a?(Hash) &&
      @opts[:serializer_opts][:include]
  end

  def denormalize_includes!(json)
    inclusions = json[:included] || []

    map_each_relationship(json) do |r|
      inclusions.detect { |i| i[:type] == r[:type] && i[:id] == r[:id] } || r
    end
  end

  def map_each_relationship(json, &block)
    records = single_record? ? [json[:data]] : json[:data]

    records.each do |record|
      record[:relationships].each_key do |assoc_name|
        relationships = record[:relationships][assoc_name][:data]

        has_many = relationships.is_a?(Array)

        new_relationships =
          if has_many
            relationships.map { |r| yield(r) }
          else
            yield(relationships)
          end

        record[:relationships][assoc_name][:data] = new_relationships
      end
    end
  end
end
