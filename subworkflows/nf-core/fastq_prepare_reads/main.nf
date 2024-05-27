
//preparing the input channel for the workflow as a metamap


// this subworkflow prepares the inputs from fastq files for the translation
// modules to include in this subworkflow

include {CUTADAPT } from '../../modules/nf-core/cutadapt/main.nf'
include {FLASH    } from '../../modules/nf-core/flash/main.nf'
include {RENAME   } from '../../modules/local/rename/main.nf'


///Users/bagordo/Desktop/all/all_bioinformatics/nf-core-nanorepertoire/data/*_{1,2}_dummy2.fastq
// main workflow
workflow FASTQ_PREPARE_READS {

    // with take we define the input channels
    take:
    input      // channel: [[id], [reads_forward, reads_reverse]]

    main:
    // define the channels that will be used to store the versions of the software

    ch_versions = Channel.empty()
    input_ch = input

    CUTADAPT(input_ch)
    ch_versions = ch_versions.mix(CUTADAPT.out.versions.first())

    FLASH(CUTADAPT.out.reads)
    ch_versions = ch_versions.mix(FLASH.out.versions.first())

    RENAME(FLASH.out.merged, single_end = true)
    ch_versions = ch_versions.mix(RENAME.out.versions.first())


    // defining the output channels that the workflow will
    emit:
    // emitted channels
    trimmed_fastq = CUTADAPT.out.fastq           // channel: [[id], [reads_forward, reads_reverse]]
    merged        = FLASH.out.fastq              // channel: [[id], [ fastq_merged ]]
    renamed       = RENAMING.out.fastq           // channel: [[id], [ fastq_renamed]]

    versions      = ch_versions                     // channel: [ versions.yml ]
}

