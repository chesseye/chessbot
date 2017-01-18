import json

def intents():
    return {
        "setup_position": [
            "Can I set up my own position?",
            "Let's set up the board.",
            "Let's set up a new position.",
            "I want to start in a new position.",
            "I would like to set up a custom position.",
            "Let's enter a new position.",
            "Please help me set up the board.",
            "Initialize a new position.",
            "Let's start from a custom position."
        ],
        "request_undo": [
            "Undo",
            "Take back",
            "I want to take that move back",
            "I want to undo that last move",
            "No no I take it back!",
            "Let's go back one move"
        ],
        "request_resign": [
            "I resign",
            "I give up",
            "You win.",
            "I forfeit the game",
            "Time for me to resign",
            "It's hopeless."
        ]
    }

def json_intents():
    # TODO
    raise Error("unimplemented")

# returns a stream of strings, one per line
def csv_intents():
    for name, alts in intents().items():
        for alt in alts:
            yield "%s,%s" % (alt.replace(",", ""), name)


# Generates all intents
if __name__ == "__main__":
    # print json.dumps(json_intents(), indent=2)
    for line in csv_intents():
        print line

