#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *(['..'] * 4), 'lib')


require 'libpath/util/windows'

require 'test/unit'


class Test_LibPath_Util_Windows_make_path_absolute < Test::Unit::TestCase

  F = ::LibPath::Util::Windows

  def test_nil

    if $DEBUG

      assert_raise(::ArgumentError) { F.make_path_absolute(nil) }
    else

      assert_nil F.make_path_absolute(nil)
    end
  end

  def test_empty

    assert_equal '', F.make_path_absolute('')
  end

  def test_absolute_paths

    assert_equal 'C:\\', F.make_path_absolute('\\', pwd: 'C:/Users/libpath-tester')
    assert_equal 'C:\\.', F.make_path_absolute('\\.', pwd: 'C:/Users/libpath-tester')
    assert_equal 'C:\\a', F.make_path_absolute('\\a', pwd: 'C:/Users/libpath-tester')
    assert_equal 'C:\\a\\.', F.make_path_absolute('\\a\\.', pwd: 'C:/Users/libpath-tester')

    assert_equal 'C:/', F.make_path_absolute('/', pwd: 'C:/Users/libpath-tester')
    assert_equal 'C:/.', F.make_path_absolute('/.', pwd: 'C:/Users/libpath-tester')
    assert_equal 'C:/a', F.make_path_absolute('/a', pwd: 'C:/Users/libpath-tester')
    assert_equal 'C:/a/.', F.make_path_absolute('/a/.', pwd: 'C:/Users/libpath-tester')

    assert_equal 'G:\\abc\\', F.make_path_absolute('G:\\abc\\')
    assert_equal 'G:\\abc\\', F.make_path_absolute('G:\\\\abc\\\\')
    assert_equal 'G:\\abc\\', F.make_path_absolute('G:\\\\abc\\\\', pwd: 'C:/Users/libpath-tester')
  end

  def test_absolute_paths_with_canonicalisation

    pwd = 'X:\\some-dir'

    options = { make_canonical: true }

    assert_equal 'X:/', F.make_path_absolute('/', **options, pwd: pwd)
    assert_equal 'X:/', F.make_path_absolute('/.', **options, pwd: pwd)
    assert_equal 'X:/a', F.make_path_absolute('/a', **options, pwd: pwd)
    assert_equal 'X:/a/', F.make_path_absolute('/a/.', **options, pwd: pwd)
  end

  def test_relative_path_with_fixed_pwd

    pwd = 'X:\\some-path\\\\or-other'

    assert_equal 'X:\\some-path\\or-other\\.', F.make_path_absolute('.', pwd: pwd)
    assert_equal 'X:\\some-path\\or-other\\', F.make_path_absolute('.', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-path\\or-other\\abc', F.make_path_absolute('abc', pwd: pwd)
    assert_equal 'X:\\some-path\\or-other\\abc', F.make_path_absolute('abc', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-path\\or-other\\./abc', F.make_path_absolute('./abc', pwd: pwd)
    assert_equal 'X:\\some-path\\or-other\\abc', F.make_path_absolute('./abc', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-path\\or-other\\./abc/', F.make_path_absolute('./abc/', pwd: pwd)
    assert_equal 'X:\\some-path\\or-other\\abc/', F.make_path_absolute('./abc/', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-path\\or-other\\def/../abc', F.make_path_absolute('def/../abc', pwd: pwd)
    assert_equal 'X:\\some-path\\or-other\\abc', F.make_path_absolute('def/../abc', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-path\\or-other\\def/../abc/', F.make_path_absolute('def/../abc/', pwd: pwd)
    assert_equal 'X:\\some-path\\or-other\\abc/', F.make_path_absolute('def/../abc/', pwd: pwd, make_canonical: true)
  end

  def test_relative_path_with_fixed_home

    home = 'X:\\Documents and Settings\\libpath-tester'

    assert_equal 'X:\\Documents and Settings\\libpath-tester', F.make_path_absolute('~', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester', F.make_path_absolute('~', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester/.', F.make_path_absolute('~/.', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester/', F.make_path_absolute('~/.', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester\\.', F.make_path_absolute('~\\.', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester\\', F.make_path_absolute('~\\.', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester/abc', F.make_path_absolute('~/abc', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester/abc', F.make_path_absolute('~/abc', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester/./abc', F.make_path_absolute('~/./abc', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester/abc', F.make_path_absolute('~/./abc', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester/./abc/', F.make_path_absolute('~/./abc/', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester/abc/', F.make_path_absolute('~/./abc/', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester/def/../abc', F.make_path_absolute('~/def/../abc', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester/abc', F.make_path_absolute('~/def/../abc', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester/def/../abc/', F.make_path_absolute('~/def/../abc/', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester/abc/', F.make_path_absolute('~/def/../abc/', home: home, make_canonical: true)
  end

  def test_relative_path_with_fixed_home_2

    home = 'X:\\Documents and Settings\\libpath-tester\\'

    assert_equal 'X:\\Documents and Settings\\libpath-tester\\', F.make_path_absolute('~', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester\\', F.make_path_absolute('~', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester\\', F.make_path_absolute('~/', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester\\', F.make_path_absolute('~/', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester\\.', F.make_path_absolute('~/.', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester\\', F.make_path_absolute('~/.', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester\\abc', F.make_path_absolute('~/abc', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester\\abc', F.make_path_absolute('~/abc', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester\\./abc', F.make_path_absolute('~/./abc', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester\\abc', F.make_path_absolute('~/./abc', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester\\./abc/', F.make_path_absolute('~/./abc/', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester\\abc/', F.make_path_absolute('~/./abc/', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester\\def/../abc', F.make_path_absolute('~/def/../abc', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester\\abc', F.make_path_absolute('~/def/../abc', home: home, make_canonical: true)

    assert_equal 'X:\\Documents and Settings\\libpath-tester\\def/../abc/', F.make_path_absolute('~/def/../abc/', home: home)
    assert_equal 'X:\\Documents and Settings\\libpath-tester\\abc/', F.make_path_absolute('~/def/../abc/', home: home, make_canonical: true)
  end

  def test_nonhome_tilde_with_fixed_pwd

    pwd = 'X:\\some-other-path\\'

    assert_equal 'X:\\some-other-path\\~.', F.make_path_absolute('~.', pwd: pwd)
    assert_equal 'X:\\some-other-path\\~.', F.make_path_absolute('~.', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-other-path\\~abc', F.make_path_absolute('~abc', pwd: pwd)
    assert_equal 'X:\\some-other-path\\~abc', F.make_path_absolute('~abc', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-other-path\\~./abc', F.make_path_absolute('~./abc', pwd: pwd)
    assert_equal 'X:\\some-other-path\\~./abc', F.make_path_absolute('~./abc', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-other-path\\~./abc/', F.make_path_absolute('~./abc/', pwd: pwd)
    assert_equal 'X:\\some-other-path\\~./abc/', F.make_path_absolute('~./abc/', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-other-path\\~def/../abc', F.make_path_absolute('~def/../abc', pwd: pwd)
    assert_equal 'X:\\some-other-path\\abc', F.make_path_absolute('~def/../abc', pwd: pwd, make_canonical: true)

    assert_equal 'X:\\some-other-path\\~def/../abc/', F.make_path_absolute('~def/../abc/', pwd: pwd)
    assert_equal 'X:\\some-other-path\\abc/', F.make_path_absolute('~def/../abc/', pwd: pwd, make_canonical: true)
  end
end


# ############################## end of file ############################# #

