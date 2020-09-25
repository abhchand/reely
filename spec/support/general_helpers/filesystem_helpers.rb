module GeneralHelpers
  def stub_env(envs)
    stub_const('ENV', ENV.to_hash.merge(envs))
  end

  def reset_dir!(dir)
    FileUtils.mkdir_p(dir)

    all_files = Dir.glob("#{dir}/*")
    FileUtils.rm_rf(all_files)
  end
end
