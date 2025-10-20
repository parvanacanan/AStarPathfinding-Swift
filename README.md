# AStarPathfinding-Swift
### A* Analysis

1. Optimality:
   - UCS, A* Euclidean və A* Manhattan hamısı eyni optimal cost-u tapdı.
   - Heuristics hamısı admissible olduğu üçün nəticə eynidir.

2. Efficiency:
   - Expanded nodes:
       UCS: 35
       A* Euclidean: 25
       A* Manhattan: 20
   - Runtime:
       UCS > Euclidean > Manhattan
   - Manhattan heuristic UCS və Euclidean-dan daha effektivdir, çünki pointwise daha böyükdür.

3. Heuristic validity:
   - Bütün edge weights ≥ Euclidean və Manhattan distance üçün true
   - Heuristics admissible və consistent.
