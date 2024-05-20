from pprint import pprint
from unidecode import unidecode
SKIP_HEADER = True
FILE_PATH = './data.csv'
DB_NAME = '../db.pl'
DECISION_NAME = 'football_decision'
FEATURE_NAME = 'football_feature'
NOTHING = "nic"

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

    unique_decisions = {(row[0], row[-1]) for row in rows}
    sub_data = []
    for decision in unique_decisions:
        if decision[0] != "" and decision[1] != "":
            sub_data.append((int(decision[0]), get_decision(decision[0], decision[1])))
    data.extend(x[1] for x in sorted(sub_data, key=lambda item: item[0]))
    data.append('')

    attributes = {i: [] for i in range(1, len(rows[0]) - 1)}
    for row in rows:
        all_empty = all(value == "" for value in row)
        if all_empty:
            continue
        id = row[0]
        for i in range(1, len(row) - 1):
            attribute = row[i]
            if attribute == "":
                attribute = NOTHING
            variable = variables[i - 1]
            attributes[i].append(get_attribute(id, variable, attribute))

    for key in attributes.keys():
        group = attributes[key]
        data.extend(group)
        data.append('')

    save_database(data)


def process_attribute(value):
    return unidecode(value.strip().lower().replace(' ', '_'))

def process_decision(value):
    return unidecode(value.strip())

def get_decision(id, value):
    return f'{DECISION_NAME}({id}, \'{value}\').'

def get_attribute(id, name, value):
    return f'{FEATURE_NAME}({id}, {name}, {value}).'

def save_database(data):
    with open(DB_NAME, 'w') as file:
        for row in data:
            file.write(row)
            file.write('\n')

if __name__ == '__main__':
    main()
