IN = open("./family.ged", "r", encoding="utf8")
OUT = open("./family.pl", "w", encoding="utf8")

cur = 0

people = {}
P = {}

children = []
parents = []

lastId = -1

cnt = 0

for line in IN:
    line = line[:-1]
    if line[len(line) - 1] == '/':
        pos = -1
        for i in range(0, len(line)):
            if line[i] == '/':
                pos = i
                break
        line = line[:pos - 1]
    words = line.split(" ")
    if words[len(words) - 1] == "INDI":
        lastId = words[1]
        people[lastId] = {"name": "", "sex": ""}
        P[lastId] = {}
        P[lastId]["children"] = []
        cur = cur + 1
    if words[1] == "NAME" and lastId != -1:
        people[lastId]["name"] = line[7:]
    if words[1] == "SEX" and lastId != -1:
        people[lastId]["sex"] = words[2]
    if words[1] == "HUSB" or words[1] == "WIFE":
        parents.append(words[2])
    if words[1] == "CHIL":
        children.append(words[2])
    if words[len(words) - 1] == "FAM":
        if len(children) > 0:
            for parent in parents:
                for child in children:
                    P[parent]["children"].append(child)
        children = []
        parents = []

if len(children) > 0:
    for parent in parents:
        for child in children:
            P[parent]["children"].append(child)

for item in people:
    OUT.write("sex(\'" + people[item]["name"] + "\', " + "\'" + people[item]["sex"] + "\').\n")

for parent in people:
    for child in P[parent]["children"]:
        OUT.write("parent(\'" + people[parent]["name"] + "\', " + "\'" + people[child]["name"] + "\'" + ").\n")

IN.close()
OUT.close()
