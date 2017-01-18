import datetime
import json

def squares():
    for c in "abcdefgh":
        for r in "12345678":
            yield "%s%s" % (c, r)

def entities():
    return {
        "color": [
            [ "white" ],
            [ "black" ]
        ],
        "figure": [
            [ "king" ],
            [ "queen" ],
            [ "rook", "tower" ],
            [ "bishop" ],
            [ "knight", "horse" ],
            [ "pawn" ]
        ],
        "square": [
            [ s ] for s in squares()
        ],
        "castle": [
            [ "queen-side castle", "queenside castle", "long castle", "queen-side", "queenside", "long" ],
            [ "king-side castle", "kingside castle", "short castle", "king-side", "kingside", "short" ]
        ],
        "pair-selector": [
            [ "both" ],
            [ "neither" ],
            [ "former", "first" ],
            [ "latter", "second" ]
        ]
    }

def json_entities():
    now = datetime.datetime.now().isoformat()[:-3] + "Z"

    def val(alts):
        return {
            "value": alts[0],
            "created": now,
            "updated": now,
            "metadata": None,
            "synonyms": alts[1:]
        }

    def obj(name, altss):
        return {
            "type": None,
            "entity": name,
            "source": None,
            "values": [ val(alts) for alts in altss ]
        }

    return {
        "entities" : [ obj(name, altss) for name, altss in entities().items() ]
    }

# returns a stream of strings, one per line
def csv_entities():
    for name, altss in entities().items():
        for alts in altss:
            yield "%s,%s" % (name, ",".join(alts))


# Generates all entities
if __name__ == "__main__":
    # print json.dumps(json_entities(), indent=2)
    for line in csv_entities():
        print line

