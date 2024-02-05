# currency-exchange-core

## Development process
The goal of this repo is to master TDD approach to development.
 

## Measuring Exchange Rates

### Bilateral exchange rate

A bilateral exchange rate refers to the value of one currency relative to another.
For example, an AUD/USD exchange rate of 0.75 means that you will get US75 cents for every AUD1 that is converted to US dollars.

### Cross rates

Bilateral exchange rates also provide a basis for calculating ‘cross rates’. 
A cross rate is an exchange rate calculated by reference to a third currency.
For instance, if the exchange rate for the euro (EUR) against the US dollar is known as well as for the Australian dollar against the US dollar, the exchange rate between the euro and the Australian dollar (EUR/AUD) can be calculated by using the AUD/USD and EUR/USD rates (that is, EUR/AUD = EUR/USD x USD/AUD).

### Trade-weighted index (TWI)

...
https://www.rba.gov.au/education/resources/explainers/exchange-rates-and-their-measurement.html


## Numbers manipulation (Decimal vs Double)

https://www.jessesquires.com/blog/2022/02/01/decimal-vs-double/

Decimal is for when you care about decimal values. Money is a very common example. If it’s critical that 0.1 + 0.2 is precisely 0.3, then you need a Decimal. If, on the other hand, you need 1/3 * 3 to precisely equal 1, then you need a rational type.

No number system is perfectly precise. There is always some rounding. The big question is whether you want the rounding to be in binary or decimal. Rounding in binary is more efficient, but rounding in decimal is more useful for certain decimal-centric problems.

(But I don’t generally recommend Decimal for money. I recommend Int, and store everything in the base unit, most commonly “cents.” It’s more efficient and often easier to use. Dollars or Euros are for formatting, not computation.)

If you want to handle all the national currencies (except the recent El Salvador experiment), you need 3 decimal places rather than 2, but 2 will get you most of them. So you can work in 0.1 units and convert from there for the whole world.

Double isn’t an imprecise number format. It’s extremely precise. It just isn’t in base-10, so some common base-10 values are repeating fractions. If 1/3 were a really common value, then base-10 would be horrible, and we’d talk about storing in base-3 to avoid losing precision.

### Two benefits of Decimal:
You can do precise decimal calculations. e.g. add Double of 0.1 ten times ≠ 1.0 (!)
You want to enjoy more significant digits. e.g. print Double representation of 12345678901234567890 and it’s not actually 12345678901234567890.


### Here I'm using Arlo's notation for micro commits
 
Reference: https://github.com/RefactoringCombos/ArlosCommitNotation
