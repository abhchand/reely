require 'rails_helper'

RSpec.describe ContentImportQueueingJob, type: :worker do
  let(:import_dir) { Rails.configuration.x.default_import_dir }
  let(:owner) { create(:user) }

  before { reset_dir!(import_dir) }

  it 'queues a ContentImportJob for each file' do
    owner_a = owner
    owner_b = create(:user)

    # rubocop:disable Metrics/LineLength
    file_a =
      create_import_file(owner: owner_a, fixture: 'images/atlanta.jpg').to_s
    file_b =
      create_import_file(owner: owner_b, fixture: 'images/atlanta.jpg').to_s
    # rubocop:enable Metrics/LineLength

    ContentImportQueueingJob.new.perform

    actual = queued_jobs
    expected = [[owner_a.id, file_a], [owner_b.id, file_b]]

    expect(actual).to match_array(expected)
  end

  it 'includes nested files in subdirectories' do
    file =
      create_import_file(
        owner: owner, fixture: 'images/atlanta.jpg', target_subpath: 'foo/bar'
      ).to_s

    ContentImportQueueingJob.new.perform

    actual = queued_jobs
    expected = [[owner.id, file]]

    expect(actual).to match_array(expected)
  end

  context 'REELY_IMPORT_DIR is set' do
    let(:import_dir) { Rails.configuration.x.default_import_dir.join('abcdef') }

    before { stub_env('REELY_IMPORT_DIR' => import_dir) }

    it 'overrides the directory location' do
      file =
        create_import_file(owner: owner, fixture: 'images/atlanta.jpg').to_s

      ContentImportQueueingJob.new.perform

      actual = queued_jobs
      expected = [[owner.id, file]]

      expect(actual).to match_array(expected)
      expect(file).to match(%r{\/abcdef\/})
    end
  end

  describe 'finding by User#synthetic_id based on top level directories' do
    it 'ignores directories that do not match any owners' do
      _file =
        create_import_file(
          synthetic_id: 'ypm6t2qaa3zfttcba5ncflwmwxor',
          fixture: 'images/atlanta.jpg'
        ).to_s

      ContentImportQueueingJob.new.perform

      actual = queued_jobs
      expected = []

      expect(actual).to match_array(expected)
    end

    it 'is case sensitive' do
      _file =
        create_import_file(
          synthetic_id: owner.synthetic_id.upcase, fixture: 'images/atlanta.jpg'
        ).to_s

      ContentImportQueueingJob.new.perform

      actual = queued_jobs
      expected = []

      expect(actual).to match_array(expected)
    end
  end

  it 'ignores files with invalid mime types' do
    _file = create_import_file(owner: owner, fixture: 'text/quotes.md').to_s

    ContentImportQueueingJob.new.perform

    actual = queued_jobs
    expected = []

    expect(actual).to match_array(expected)
  end

  def queued_jobs
    ContentImportJob.jobs.map { |j| j['args'] }
  end
end
