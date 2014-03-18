module RepositoryHelper

  def initialize_repo_dir
    prepare_empty_repo_dir
    gpgroup.init
  end

  def prepare_empty_repo_dir
    FileUtils.rm_rf(repo_dir)
    FileUtils.mkpath(repo_dir)
    FileUtils.chdir(repo_dir)
  end

  def repo_dir
    $root.join('tmp/repo')
  end

end
