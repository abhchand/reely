module GeneralHelpers
  def clear_storage!
    unless Rails.env.test?
      raise "`clear_storage!` can only be called on test environment"
    end

    storage_dir = ActiveStorage::Blob.service.root
    `rm -rf #{storage_dir}/*`
  end

  module_function :clear_storage!
end
