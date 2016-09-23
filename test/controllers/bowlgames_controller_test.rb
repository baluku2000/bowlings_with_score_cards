require 'test_helper'

class BowlgamesControllerTest < ActionController::TestCase
  ERR_NOT_AS_EXPECTED = "Error msg shown not as expected"

  test "should get expected error msg if input string not a valid stringized array" do
    get :new
    input_frames = '[[6,1],[9,],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[4,5],[10,1,2]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Invalid Input Frames/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if total frames not equals 10" do
    get :new
    # input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[]]'
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[4,5],[10,1,2]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Input array must be 10 units long/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if non-tenth frame has non integer entries" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,"1"],[10,1,2]]'
    # input_frames = '[[6,1],[9,"e"],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[10,1,1]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /must contain only integer entries/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if non-tenth frame empty or has more than 2 throws" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[10],[5,3],[0,3],[10],[],[10,1,2]]'
    # input_frames = '[[6,1],[9,1],[1,8],[10],[10],[5,2,3],[0,3],[10],[5,1],[10,1,2]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /must not be empty and length must not exceed 2/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 1-throw non-tenth frame has downed pins not equals 10" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[1],[1,0],[5,2],[0,3],[10],[5,1],[10,10,1]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /with single entry must have value 10/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 2-throws non-tenth frame has invalid throw1" do
    get :new
    input_frames = '[[6,1],[9,1],[11,8],[10],[1,0],[5,2],[0,3],[10],[5,1],[10,10,1]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Invalid throw no. 1/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 2-throws non-tenth frame has invalid throw2" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[0,11],[5,2],[0,3],[10],[5,1],[10,10,1]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Invalid throw no. 2/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 2-throws non-tenth frame has downed pins exceeding 10" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,6],[0,3],[10],[5,1],[10,10,10]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Throws 1 and 2 together must not exceed 10 pins/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if tenth frame has non integer entries" do
    get :new
    # input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[10,1,"2"]]'
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[10,1,"e"]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Tenth subarray must contain only integer entries/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if tenth frame empty or has more than 3 throws" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[]]'
    # input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[10,1,2,3]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Tenth subarray must not be empty and length must not exceed 3/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if tenth frame has only 1 throw" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[3]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Tenth subarray cannot have only 1 entry/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 2-throws tenth frame has invalid throw1" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[11,0]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Tenth subarray: Invalid throw no. 1/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 2-throws tenth frame has invalid throw2" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[0,11]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Tenth subarray: Invalid throw no. 2/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 2-throws tenth frame has downed pins exceeding 10" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[2,9]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Tenth subarray: Throws 1 and 2 together must not exceed 10 pins/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 3-throws tenth frame has 1st throw being non-strike" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[2,10,1]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Tenth subarray: 1st throw of a 3-throws tenth frame must be 10 pins/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 3-throws tenth frame has invalid throw2" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[10,11,1]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Tenth subarray: Invalid throw for no. 2/, response.body, ERR_NOT_AS_EXPECTED
  end

  test "should get expected error msg if a 3-throws tenth frame has invalid throw3" do
    get :new
    input_frames = '[[6,1],[9,1],[1,8],[10],[4,1],[5,2],[0,3],[10],[5,1],[10,1,11]]'
    xhr :post, :create, { :frames => input_frames }
    assert_match /Tenth subarray: Invalid throw for no. 3/, response.body, ERR_NOT_AS_EXPECTED
  end

end
