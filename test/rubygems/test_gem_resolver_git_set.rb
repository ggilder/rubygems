require 'rubygems/test_case'

class TestGemResolverGitSet < Gem::TestCase

  def setup
    super

    @set = Gem::Resolver::GitSet.new

    @reqs = Gem::Resolver::RequirementList.new
  end

  def test_add_git_gem
    name, version, repository, = git_gem

    @set.add_git_gem name, repository, 'master'

    dependency = dep 'a'

    specs = @set.find_all dependency

    assert_equal "#{name}-#{version}", specs.first.full_name
  end

  def test_find_all
    name, version, repository, = git_gem

    @set.add_git_gem name, repository, 'master'

    dependency = dep 'a', '~> 1.0'
    req = Gem::Resolver::ActivationRequest.new dependency, nil
    @reqs.add req

    @set.prefetch @reqs

    found = @set.find_all dependency

    assert_equal [@set.specs['a']], found
  end

  def test_prefetch
    name, _, repository, = git_gem

    @set.add_git_gem name, repository, 'master'

    dependency = dep name
    req = Gem::Resolver::ActivationRequest.new dependency, nil
    @reqs.add req

    @set.prefetch @reqs

    refute_empty @set.specs
  end

  def test_prefetch_filter
    name, _, repository, = git_gem

    @set.add_git_gem name, repository, 'master'

    dependency = dep 'b'
    req = Gem::Resolver::ActivationRequest.new dependency, nil
    @reqs.add req

    @set.prefetch @reqs

    assert_empty @set.specs
  end

end
