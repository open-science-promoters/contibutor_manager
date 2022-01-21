library("ontologyIndex")
library ("dplyr")
cro= get_ontology("https://raw.githubusercontent.com/data2health/contributor-role-ontology/master/cro.obo", propagate_relationships=c("is_a", "part_of"), extract_tags="everything")
credit =get_ontology("https://raw.githubusercontent.com/data2health/credit-ontology/master/credit.obo", extract_tags="everything")

#add name and def to credit element of cro, in cro
for (creditid in c(credit$id)){
  if (grepl("CREDIT",creditid )){
    #print (creditid)
    cro$name [cro$id ==creditid] <- credit$name[credit$id ==creditid]
    cro$def [cro$id ==creditid] <- credit$def[credit$id ==creditid]
  }
}

## creating the table, with hierachy on 3 levels

parents =data.frame("level1"=cro$name [cro$parents == "CRO:0000000"], "level1id"=cro$id [cro$parents == "CRO:0000000"]) #%>%
  #filter (!is.na(level1)) 

## get children
childtot = data.frame()
for (i in parents$level1id){
  #i ="CREDIT_00000013"
  child = data.frame("level2"=cro$name [cro$parents == i], "level2id"=cro$id [cro$parents == i]) %>%
    mutate ("level1id" = i)
  
  childtot = rbind(childtot, child)
}

#names (creditdata) = c("level2", "level2id")

sec_level=full_join(childtot,parents)  
childtot = rbind (childtot, parents %>% mutate ("level2id" =level1id) %>% mutate ("level2"= "NA") %>% select (- level1))
parents=full_join(childtot,parents)  

## get second layer children
childtot = data.frame()
for (i in sec_level$level2id){
  #i ="CRO:0000001"
  child = data.frame("level3"=cro$name [cro$parents == i], "level3id"=cro$id [cro$parents == i]) %>%
    mutate ("level2id" = i)
  
  childtot = rbind(childtot, child)
}

parents=full_join(childtot%>% filter (!is.na (level3id)),parents) 
#names(parents)

# prepare table
final=parents %>%
  mutate (Term = gsub("--NA", "",paste (level1,level2,level3, sep = "--"))) %>%
  mutate (Lastid=ifelse (is.na(level3id),as.character(level2id),as.character(level3id))) %>%
  mutate (URL=ifelse (is.na(Lastid),as.character(level1id),Lastid))%>%
  select (Term, URL)%>%
  arrange(Term) 

# add definitions
description = data.frame("URL"=cro$id,  cro$def)
View (description)

final = left_join (final, description)
#
View(final)


write.table(final, file = "contributorlist_creator/dependencies/creditroles.csv", sep = "\t", row.names = FALSE)


# ## deprecated stuff
# creditdata = parents =data.frame("level1"=credit$name [credit$parents == "CREDIT_00000000"], "level1id"=credit$id [credit$parents == "CREDIT_00000000"]) %>%
#  filter (!is.na(level1)) 
# parents = left_join(parents, creditdata, by="level1id") %>%
#   mutate (level1 = ifelse (is.na (level1.x),as.character(level1.y),as.character(level1.x) )) %>%
#   select (-level1.y, -level1.x)
# childtot = left_join(childtot, creditdata, by="level2id") %>%
#   mutate (level2 = ifelse (is.na (level2.x),as.character(level2.y),as.character(level2.x) )) %>%
#   select (-level2.y, -level2.x)