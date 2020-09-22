# Serializes a single record or a collection of records into the JsonAPI format
# See: https://jsonapi.org/
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
    @serializer.new(
      @dataset,
      @opts[:serializer_opts] || {}
    ).serializable_hash
  end
end
