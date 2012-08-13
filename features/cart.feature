Feature: Cart

  Scenario: Initial state

    The visitor does not have a cart until an item is added

    When I visit the homepage
    Then my cart should be empty

  Scenario: Add item to cart

    Given there are current events
    When I visit the homepage
    And I add an event to my cart
    Then my cart should contain:
      | quantity |
      | 1        |

  Scenario: Add item to cart again

    Multiple copies of an item can be added. They should appear in a single cart row.

    Given the events:
      | Crete Boom           |
      | The Crete Boom       |
    When I visit the homepage
    And I add "The Crete Boom" to my cart
    And I add "The Crete Boom" to my cart again
    Then my cart should contain:
      | event                | quantity |
      | The Crete Boom       | 2        |

  Scenario: Add different items to cart

    Items should appear in the order they were added

    Given the events:
      | Crete Boom           |
      | The Crete Boom       |
    When I visit the homepage
    And I add "The Crete Boom" to my cart
    And I add "Crete Boom" to my cart
    Then my cart should contain:
      | event                | quantity |
      | The Crete Boom       | 1        |
      | Crete Boom           | 1        |

  Scenario: Empty cart

    Given my cart contains events
    When I empty my cart
    Then my cart should be empty

