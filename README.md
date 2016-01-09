Mesh Testbed Generator
=======================

Buildsystem to generate custom OpenWRT-Firmware files for different nodes in a testbed.

Motivation
-------------
Having set up a mesh of 5 TP Link TL-WR842nd v2, there's a need for configuration management. Configuration should be:
* Consistent / DRY
* Revertable - especially using `first_boot` 
* Under version control

To archieve these goals, a OpenWRT-configuration is generated based on Ruby `.erb` templates. A dedicated firmware file is generated for each node.

Structure
-----------------
* `nodes.yml - inventory of all nodes. A firmware-file is generated per node
* `files` - Directory of .ERB-templates. After processing all ERB-templates, it is integrated into the firmware files
* `bin` - Output folder for firmware files
* `Rakefile` - Central build file

Usage
---------------
# Adapt `nodes.yml`
# Adapt templates in `files`
# Run `rake`

OpenWRT Release (Chaos Calmer) and Platform (TL-WR842nd v2) is hardcoded in `Rakefile`. You have to change it to support other platforms.



