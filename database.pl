% football_situation(ID, ball out?, which line?, pass?, was offside?, which team?, DECISION).
football_situation(1, 'yes', 'goal_line', 'no', 'no', 'team1', 'goal').
football_situation(2, 'yes', 'goal_line', 'no', 'yes', 'team2', 'goal').
football_situation(3, 'no', _, 'yes', 'yes', 'team1', 'offside').
football_situation(4, 'no', _, 'yes', 'yes', 'team2', 'offside').
football_situation(5, 'no', _, 'yes', 'yes', 'team3', 'offside3').