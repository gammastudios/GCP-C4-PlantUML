# GCP-C4-PlantUML
PlantUML template library to render [C4 diagrams](https://c4model.com/) using GCP and Firebase resource icons.  Includes the C4 templates, as well as the complete GCP and Firebase Icon Libraries. Also includes smaller icons with be used in sequence and activity diagrams.
## Usage
Add the following `include` statements after the `@startuml` label:

    !define GCPPuml https://raw.githubusercontent.com/gamma-data/GCP-C4-PlantUML/master/templates
    !includeurl GCPPuml/C4_Context.puml
    !includeurl GCPPuml/C4_Component.puml
    !includeurl GCPPuml/C4_Container.puml
    !includeurl GCPPuml/GCPC4Integration.puml
    !includeurl GCPPuml/GCPCommon.puml
    
    ' add required services here...    
    !includeurl GCPPuml/Compute/ComputeEngine.puml
    !includeurl GCPPuml/Storage/CloudStorage.puml
## C4 Example
![Example GCP Component Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/gamma-data/GCP-C4-PlantUML/master/examples/gcp-C4-example.puml)
## Sequence Diagram Example
This template library can also be used to generate sequence diagrams using GCP resources, as shown below:
![Example GCP Sequence Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/gamma-data/GCP-C4-PlantUML/master/examples/gcp-sequence-diagram-example.puml)