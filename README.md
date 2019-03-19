## Network
• "API Call", basically reads the bundled JSON file and serializes the data
• "Request" is made only once, and when the HomeViewController is loaded

## Storage
• Using CoreData to store just Shift entities
• No IDs for the objects, so we destroy our persistent store before booting, each time (only happens on first launch, we don't really handle what happens if the app comes back from the background)


## Shifts List
• An NSFetchedResultsController backed table view that watches for any Shifts changes
• Colors are hardcoded

## Creating a new shift
• Build a Shift in a child NSManagedObjectContext and only persist it if the user chooses to save.
• Basic UIDatePickers for times (would customize further to only allow hours), limits the shifts to 30 minute intervals
• Employees and Colors are selected only form the values that we've already serialized
