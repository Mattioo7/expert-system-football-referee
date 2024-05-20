from pprint import pprint
from unidecode import unidecode
SKIP_HEADER = True
FILE_PATH = './data.csv'
DB_NAME = '../db.pl'
DECISION_NAME = 'football_decision'
FEATURE_NAME = 'football_feature'
VARIABLES_NAME = 'football_variable_names'
NOTHING = "brak"
DYNAMIC_CLAUSE = ":- dynamic {0}/{1}."

DECISION_VARIABLE_NAME = 'decision'
variables = [
    "what_happened",
    "ball_out_line",
    "end_line_side",
    "last_touch_team",
    "pass_offside",
    "pass_receiver_position",
    "passing_team",
    "legal_contact",
    "foul_dynamics",
    "player_touched_location",
    "foul_location",
    "rule_breaker",
    "goal_side",
    "hand_touch_location",
    "hand_touch_player",
    "hand_stopped_play",
    "person_1",
    "person_2",
    "insults",
    "first_insult",
    "yellow_card_status"
]

def main():
    with open(FILE_PATH, 'r') as file:
        rows = file.readlines()
        rows = [x.split(',') for x in rows]
        rows = [[process_decision(row[i]) if i == len(row) - 1 else process_attribute(row[i]) for i in range(len(row))] for row in rows]
        if SKIP_HEADER:
            rows = rows[1:]

    data = []

    # Get possible decisions
    unique_decisions = {row[-1] for row in rows if row[-1] != ""}
    data.append(DYNAMIC_CLAUSE.format(DECISION_NAME, 2))
    data.append('')
    data.extend(get_decision(process_attribute(x), x) for x in unique_decisions)
    data.append('')

    
    # Get attributes for each rule
    attributes = {i: [] for i in range(len(rows[0]) - 1)}
    for row in rows:
        all_empty = all(value == "" for value in row)
        if all_empty:
            continue
        id = row[0]

        # Process decision
        decision_key = process_attribute(row[-1])
        attributes[0].append(get_attribute(id, DECISION_VARIABLE_NAME, decision_key))

        # Process other variables
        for i in range(1, len(row) - 1):
            attribute = row[i]
            if attribute == "":
                attribute = NOTHING
            variable = variables[i - 1]
            attributes[i].append(get_attribute(id, variable, attribute))

    data.append(DYNAMIC_CLAUSE.format(FEATURE_NAME, 3))
    data.append('')
    for key in attributes.keys():
        group = attributes[key]
        data.extend(group)
        data.append('')

    # data.append(get_variables())
    # data.append('')

    save_database(data)


def process_attribute(value):
    return unidecode(value.strip().lower().replace(' ', '_'))

def process_decision(value):
    return unidecode(value.strip())

def get_decision(id, value):
    return f'{DECISION_NAME}({id}, \'{value}\').'

def get_attribute(id, name, value):
    return f'{FEATURE_NAME}({id}, {name}, {value}).'

def get_variables():
    return f'{VARIABLES_NAME}({", ".join(variables)}).'

def save_database(data):
    with open(DB_NAME, 'w') as file:
        for row in data:
            file.write(row)
            file.write('\n')

if __name__ == '__main__':
    main()
