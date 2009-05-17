Feature: explicit subject

  You can override the implicit subject using the subject() method.
  
  Scenario: subject in top level group
    Given the following spec:
      """
      describe Array, "with some elements" do
        subject { [1,2,3] }
        it "should have the prescribed elements" do
          subject.should == [1,2,3]
        end
      end
      """
    When I run it with the spec command
    Then the stdout should match "1 example, 0 failures"

  Scenario: subject in a nested group
    Given the following spec:
      """
      describe Array do
        subject { [1,2,3] }
        describe "with some elements" do
          it "should have the prescribed elements" do
            subject.should == [1,2,3]
          end
        end
      end
      """
    When I run it with the spec command
    Then the stdout should match "1 example, 0 failures"
