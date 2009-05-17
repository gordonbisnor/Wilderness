Feature: custom matcher shortcut

  In order to express my domain clearly in my code examples
  As a non-rspec user
  I want a shortcut for create custom matchers

  Scenario: creating a matcher with default messages
    Given a file named test_multiples.rb with:
      """
      $:.unshift File.join(File.dirname(__FILE__), "/../lib")
      require 'test/unit'
      require 'spec/expectations'
      
      Spec::Matchers.create :be_a_multiple_of do |expected|
        match do |actual|
          actual % expected == 0
        end
      end
      
      class Test::Unit::TestCase
        include Spec::Matchers
      end
      
      class TestMultiples < Test::Unit::TestCase
      
        def test_9_should_be_a_multiple_of_3
          9.should be_a_multiple_of(3)
        end

        def test_9_should_be_a_multiple_of_4
          9.should be_a_multiple_of(4)
        end
        
      end
      """
    When I run it with the ruby interpreter
    Then the exit code should be 256
    And the stdout should match "expected 9 to be a multiple of 4"
    And the stdout should match "2 tests, 0 assertions, 1 failures, 0 errors"
