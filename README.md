Credit Card Processor
====================
This is a basic Rails app built for the command line consisting of two PostgreSQL tables: `credit_cards` and `transactions`.
CreditCards and Transactions were built as ActiveRecord models in order to (1) fully validate each instance before committing to the database,
and (2) scope data into two associated models.

Although there is a [luhn10 validator](https://github.com/rolfb/luhn-ruby) gem available, I implemented my own in order to showcase the versatile usage of custom `ActiveModel::EachValidators`.

Setup
====================
Only necessary before running the app for the first time. If you've already completed this step, continue to [Usage](https://github.com/Zhyliana/credit_card_processor#usage).

First we need to clone the repo. This is a private repo. To share with more users, please contact me for access at zhyliana@gmail.com.
```
$ git clone git@github.com:Zhyliana/credit_card_processor.git
```

Navigate to the project:
```
$ cd credit_card_processor
```

Next, we need to setup dependencies. This script will install all dependencies and setup the database.
```
$ bin/setup
```
Note: You might need to add execute permissions to this script.
If you see `bash: bin/setup: Permission denied`, add execute permissions with `chmod +x bin/setup`.
Or if you prefer, you can run the script contents manually:
```
$ bundle install
$ rake db:create
$ rake db:migrate
$ rake db:test:prepare
```

Usage
====================
This credit card processor runs on the command line, and it can take [STDIN](https://github.com/Zhyliana/credit_card_processor#using-stdin) or a [filename](https://github.com/Zhyliana/credit_card_processor#using-a-file). After processing all line items, you will receive a summary of all accounts in which processes were attempted in alphabetical order, with the account's balance (or error state) displayed.

Note: You might need to add execute permissions to the run script. If at any point you see `bash: bin/run: Permission denied`, add execute permissions with `chmod +x bin/run`.

You're now ready to process some transactions!
Using STDIN
----------------------------------
```
$ bin/run
```

You will see a welcome line that reads:
```
Type ':wq' to save and exit
```
You can now type in each line item you would like to process. Each line must consist of one process, with each argument separated by a single space.
##### Add a credit card
```bash
# Add [first_name_of_cc_owner] [credit_card_number] [credit_card_limit]
Add Buster 4173869390482934 $1000000
```
Note: Credit cards with invalid credit card numbers are not stored.

##### Charge a credit card
```bash
# Charge [first_name_of_cc_owner] [amount_charged]
Charge Buster $500
```
Note: Transactions that would go over a credit card's limit are not processed.

##### Credit
```bash
# Credit [first_name_of_cc_owner] [amount_credited]
Credit Buster $100
```

Save and exit by adding `:wq` to a new line. You will receive a summary of all transactions attempted.

###### Example
Input:
```ruby
Add Wallace 5464120100414097 $1000
Charge Wallace $50
Credit Wallace $10
:wq
```
Returned summary:
```
-----TRANSACTION SUMMARY----------
Wallace: $40
----------------------------------
```
Using a File
----------------------------------
Simply pass in the filename as an argument of the run script.
```
$ bin/run filename.txt
```

###### Example
You can test this feature using the included file `example_input.txt`.
```
$ bin/run example_input.txt
```
You will instantly see the summary as:
```
-----TRANSACTION SUMMARY----------
Lisa: $-93
Quincy: error
Tom: $500
----------------------------------
```

Testing
====================

Spec files can be found under [`./spec/models`](https://github.com/Zhyliana/credit_card_processor/tree/master/spec/models).
Each model is tested using the [`rspec-rails`](https://github.com/rspec/rspec-rails) testing framework, in addition to the [`shoulda-matchers`](https://github.com/thoughtbot/shoulda-matchers) gem for its model validation and association testing methods.

To run all automated tests, simply run:
```bash
$ rspec
```

Questions
====================
To request access for additional users or if you have any installation questions, feel free to reach out to me at zhyliana@gmail.com.
