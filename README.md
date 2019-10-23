# like a reference managers, but for author lists:

Using a software to manage scientific publications author list, the same way reference managers work.


# This is an open source project, please join the team!

Team:
- julien colomb, ideation and initiator, julien.colomb at fu-berlin.de
- Nicole Vasilevsky, vasilevs at ohsu.edu


# Idea

Build a rshiny app to get author list via entering orcid and clicking through boxes.

1. From scratch

- GUI to get an author list:
    - enter ORCID
    - checkbox Credit
    - choose output format: download button

2. Import - converstion

- import button: fill the GUI with the data uploaded
- continue as for from scratch


## putative inputs

orcid id: author's information
ror: institutions information
xml: previous created author list

## outputs

The core format should probably be xml (converstion xxx -> xml -> yyy) ?
For publication system, they may not be able to use all information, but could pre-populate their forms using the data. (they often perform additional automatic checks during data import).

To facilitate reimport, one could think about getting a zip file containing both the output desired and the core format output. The converstion would then not need to deal with import of other formats than the core.


other output formats:
yml formated author list (for GIN, blog posts,..)
JATSxml formatted author list (for substance, sourcedata)
json formatted author list (zenodo,...)
text author list (other use)

## tools and communities to approach

OJS / pkp: Juan Pablo Alperin
jats4r
rorcid (orcid API)
force11
...
