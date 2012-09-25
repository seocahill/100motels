Feature: Cart

  Scenario: Initial state

    The visitor does not have a cart until an item is added

    When I visit the homepage
    Then I should see "Cart (0)"

  Scenario: Add item to cart

    Given the events:
      | Crete Boom         |
      | The New Crete Boom |
    When I visit the homepage
    And I click on "Info & Tickets" for "The New Crete Boom"
    And I add "The New Crete Boom" to my cart
    Then my cart should contain:
     | Quantity  | Item               |
     | 1         | The New Crete Boom |

  Scenario: Add item to cart again

    Multiple copies of an item can be added. They should appear in a single cart row.

    Given the events:
      | Crete Boom         |
      | The New Crete Boom |
    When I visit the box office
    And I add "The New Crete Boom" to my cart
    And I add "The New Crete Boom" to my cart again
    Then my cart should contain:
      | event              | quantity |
      | The New Crete Boom | 2        |

  Scenario: Add different items to cart

    Items should appear in the order they were added

    Given the events:
      | Crete Boom         |
      | The New Crete Boom |
    When I visit the box office
    And I add "The New Crete Boom" to my cart
    And I add "Crete Boom" to my cart
    Then my cart should contain:
      | event              | quantity |
      | The New Crete Boom | 1        |
      | Crete Boom         | 1        |

  Scenario: Empty cart

    Given my cart contains events
    When I empty my cart
    Then my cart should be empty