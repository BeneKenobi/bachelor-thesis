flowchart TB

subgraph entry["Possible Research Entry Points"]
direction TB
    problem((Problem-<br />Centered<br />Initiation))
    objective((Objective-<br />Centered<br />Solution))
    design_initiation(("Design &<br />Development<br />Centered<br />Initiation"))
    client(("Client/<br />Context<br />Initiated"))
end



entry -->|"Nominal process sequence"|identify_problem

identify_problem["Identify<br />Problem<br />& Motivate<br /><br /><i>Define Problem</i><br /><br /><i>Show<br />importance</i>"]
identify_problem -->|Inference| define_objectives
define_objectives["Define<br />Objectives of<br />a Solution<br /><br /><i>What would a<br />better artifact<br />accomplish?</i>"]
define_objectives -->|Theory| design
design["Design &<br />Development<br /><br /><i>Artifact</i>"]
design -->|How to<br />Knowledge| demonstration
demonstration["Demonstration<br /><br /><i>Find suitable<br />context</i><br /><br /><i>Use artifact to<br />solve problem</i>"]
demonstration -->|Metrics, Analysis<br />Knowledge| evaluation
evaluation["Evaluation<br /><br /><i>Observe how<br />effective,<br />efficient</i><br /><br /><i>Iterate back to<br />design</i>"]
evaluation -->|Disciplinary<br />Knowledge| communication
communication["Communication<br /><br /><i>Scholarly<br />publications</i><br /><br /><i>Professional<br />publications</i>"]
evaluation --->|Process Iteration| design
communication --->|Process Iteration| define_objectives

problem --- identify_problem
objective --- define_objectives
design_initiation --- design 
client --- demonstration
