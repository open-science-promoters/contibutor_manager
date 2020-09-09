[![DOI](https://zenodo.org/badge/211304521.svg)](https://zenodo.org/badge/latestdoi/211304521)

# Introduction

The present tool creates author lists out of orcid ID lists, the present output format is a spreadsheet, this spreadsheet will be compatible with the next version of tenzing (see https://github.com/marton-balazs-kovacs/tenzing/issues/22) and the two apps might be merge at some point. We work on the production of other, more complex outputs in the [JAMS project](https://github.com/jam-schema/jams).

# foreword and contribution

Dear reader, this repository is still in construction: while I have not build any contribution guide, feel free to join this journey, give feedback via issues or directly participate in the development via pull requests.

## This is an open source project, please join the team!

Team:
- julien colomb, ideation and initiator, julien.colomb at fu-berlin.de
- Nicole Vasilevsky, vasilevs at ohsu.edu




# like a reference managers, but for author lists:

Ultimate goal: using a software to manage scientific publications author list, the same way reference managers work.
Next step: create author lists from orcid numbers


# Step one: the contributor list creator


## The app


Build a rshiny app to get author list via entering orcid and clicking through boxes.

1. From scratch

- GUI to get an author:
    - enter ORCID
    - checkbox Credit
    - box for is_an_author and is_corresponding_author, default is yes/no
    - **choose affiliation**
    - add author to list.
- on the list:
        - click one author to modify information (enter data on above choice boxes)
        - choose output format: download button

2. Import - converstion

- import button: fill the GUI with the data uploaded
- continue as for from scratch


## putative inputs

- orcid id: author's information
- ror: institutions information
- json,yaml: previously created author list, import from datacite

## outputs

The core format is in discussion in https://github.com/jam-schema/jams. The application is using lists to work the data.

For publication systems, they may not be able to use all information, but could pre-populate their forms using the data. (they often perform additional automatic checks during data import).

To facilitate reimport, one could think about getting a zip file containing both the output desired and the core format output. The converstion would then not need to deal with import of other formats than the core.


other output formats:
yml formated author list (for GIN, blog posts,..)
JATSxml formatted author list (for substance, sourcedata)
json formatted author list (zenodo,...)
text author list (other use)

example output to implement:

``` 
manubot yaml
------------

github: dhimmel  # strongly suggested
name: Daniel S. Himmelstein  # mandatory
initials: DSH  # optional
orcid: 0000-0002-3012-7446  # mandatory
twitter: dhimmel  # optional
email: daniel.himmelstein@gmail.com  # suggested
affiliations:  # as a list, strongly suggested
  - Department of Systems Pharmacology and Translational Therapeutics, University of Pennsylvania
  - Department of Biological & Medical Informatics, University of California, San Francisco
funders: GBMF4552  # optional
roles:  # optional, as a list
      - CREDIT_00000013 writing original draft role
```
# Step two: contributor manager

- Information about co-authors should be saved
- Drag and drop way to create author lists
- Information (author name + affiliation) should be imported from papers metadata (from orcid? via crossref?, datacite? see https://commons.datacite.org)


## Tools and communities to approach

- OJS / pkp: Juan Pablo Alperin
- jats4r
- rorcid (orcid API)
- force11
...



## Dependencies

All authors need an orcid, with:
 - public email address in their orcid
 - full name information
 - full affiliation to be used for the author list, postal address should be indicated in the department field.
 
 The software does not allow to enter information manually, apart from affiliation.
