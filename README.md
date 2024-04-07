# CSE 216 Team Repo Mobile Branch
This is a team repository.  It is intended for use during phase 1 and beyond.
Phase 1 sprint 7: Ally Hoang
Path to dartdocs: C:\Users\WIN\Desktop\CSE216 - Team\cse216_sp24_team_02\mobile\dawgs\doc\api

- Phase 2 Sprint 8: Geo Kim

## Details
- Semester: Spring 2024
- Team Number: 02
- Team Name: dawgs
- Bitbucket Repository: https://bitbucket.org/sml3/cse216_sp24_team_02
- Pseudocode:
  * Define a group of tests for the Counter class
  * Test case: Verify that the initial value of the counter is 0
    test('value should start at 0', () {
      // Arrange: Create an instance of Counter
      // Act: No action needed
      // Assert: Check if the initial value is 0
      expect(Counter().value, 0);
    });

    // Test case: Verify that the value of the counter is incremented by 1
    test('value should be incremented', () {
      // Arrange: Create an instance of Counter
      final counter = Counter();

      // Act: Increment the counter
      counter.increment();

      // Assert: Check if the value is incremented to 1
      expect(counter.value, 1);
    });

    // Test case: Verify that the value of the counter is decremented by 1
    test('value should be decremented', () {
      // Arrange: Create an instance of Counter
      final counter = Counter();

      // Act: Decrement the counter
      counter.decrement();

      // Assert: Check if the value is decremented to -1
      expect(counter.value, -1);
    });
- Description:
  * This Dart script is a unit test file written using the test package, designed to test the functionality of the Counter class from the dawgs library. The main function serves as the entry point for the test suite. Inside the main function, there is a group function call that defines a group of tests with the description "Test start, increment, decrement". Within this group, there are three individual test cases, each defined using the test function.

## Pseudocode for Phase 2 Sprint 8

- Authentication via Google OAuth(Function performGoogleLogin)
- Description: Verify that users can successfuly log in using Google OAuth by simulating a successful login by mocking Google OAuth response. It checks whether the authentication service returns a valid user token, indicating a successful login.
  ```
  // Test case: Verify successful login via Google OAuth
  test('successful Google OAuth login', () async {
    // Arrange: Mock the Google OAuth response to simulate a successful login
    final authService = MockAuthService();
    when(authService.signInWithGoogle()).thenAnswer((_) async => 'MockUserToken');

    // Act: Attempt to log in
    final result = await authService.signInWithGoogle();

    // Assert: Check if the login result is successful
    expect(result, isNotNull);
    expect(result, equals('MockUserToken'));
  });
  ```

- Up-Voting Functionality(Function upVoteIdea)
- Description: Ensure up-voting an idea correctly increments its vote count by incrementing the vote count of a post model instance and verifying that the count increases as expected.
  ```
  // Test case: Verify up-vote increases the vote count
  test('up-vote increases vote count', () async {
    // Arrange: Create an instance of the Post model with an initial vote count
    final post = Post(voteCount: 1);

    // Act: Perform an up-vote
    post.upVote();

    // Assert: Check if the vote count increased by 1
    expect(post.voteCount, 2);
  });
  ```

- Down-Voting Functionality()
- Description: Ensure up-voting an idea correctly increments its vote count by similarly to up-voting but decrements the vote count of a post and asserts that the count decreases accordingly.
  ```
  // Test case: Verify down-vote decreases the vote count
  test('down-vote decreases vote count', () async {
    // Arrange: Create an instance of the Post model with an initial vote count
    final post = Post(voteCount: 2);

    // Act: Perform a down-vote
    post.downVote();

    // Assert: Check if the vote count decreased by 1
    expect(post.voteCount, 1);
  });
  ```