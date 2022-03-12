# Backend coding exercise

For this coding exercise you will use the public API provided by https://magicthegathering.io to build a command line tool that can query and filter Magic The Gathering cards.

## The exercise

Using **only** the https://api.magicthegathering.io/v1/cards endpoint and **without using any query parameters for filtering**, create a command-line tool that can be used by one of our engineers to query, filter, and group cards. Ensure that your tool can be used to return the following example lists:

* A list of **Cards** grouped by **`set`**.
* A list of **Cards** grouped by **`set`** and within each **`set`** grouped by **`rarity`**.
* A list of cards from the  **Khans of Tarkir (KTK)** set that ONLY have the colours `red` **AND** `blue`

Once you've finished coding, spend some time adding a section to this README explaining how you approached the problem: initial analysis, technical choices, trade-offs, etc.

## Environment

* You can use any one of the following programming languages: Ruby, Elixir, JavaScript, Crystal, Python, Go. We want to see you at your best, so use the language you're most comfortable with.
* If you introduce any dependencies outside of your programming language's standard library, document why you added them in this README.

## Limitations

* You are **not** allowed to use a third-party library that wraps the MTG API.
* You can only use the https://api.magicthegathering.io/v1/cards endpoint for fetching all the cards. You **can't use query parameters** to filter the cards.

## What we look for

* Organise your code with low coupling and high cohesion.
* Avoid unnecessary abstractions. Make it readable, not vague.
* Name things well. We know _naming things_ is one of the two hardest problems in programming, so try to not make your solution too cryptic or too clever. Avoid the use of [weasel words](https://gist.github.com/tmcw/35849b7e9b86bb0c125972b2bb275bc7).
* Adhere to your language/framework conventions. No need to get _too_ creative.
* Take a pragmatic approach to testing. Just make sure the basics are covered.
* Take your time. We set no time limit, so simply let us know roughly how much time you spent. By our estimate, it should take roughly 4 hours. It's not an issue if you go over this but PLEASE do not spend more than 6 hours on it.
