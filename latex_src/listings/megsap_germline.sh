#!/bin/bash
php /megSAP/src/Pipelines/analyze.php -folder $containerDirectory -name $sampleName -use_dragen -no_abra -system /NGS_Daten_Test/Manifest/NGSD/WGS_lotus_GRCh38.ini -threads $threads -steps $steps
