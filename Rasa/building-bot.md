# Building Bot

### Precision vs. Recall
**Precision**: Of all the records we predicted positive, what fraction are actually positive?

**Recall**: Percentage of total relevant results correctly classified by your algorithm

**Example:**
Suppose a computer program for recognizing dogs in photographs identifies 8 dogs in a picture containing 12 dogs and some cats. Of the 8 dogs identified, 5 actually are dogs (true positives), while the rest are cats (false positives). 
- Precision is 5/8 
- Recall is 5/12. 

#### F1-Score
- Balance between precision and recall

## Things you have tested
- [x] create_meeting with no name
- [x] create_meeting with name
- [ ] create_meeting with names
- [x] add_item with no name + no item
- [x] add_item with no name
- [x] add_item with no item
- [x] add_item with name and item
- [ ] help 

## Problems I ran into
- how do we deal with "all meetings" in sync case
- should we distinguish between 1:1 and meetings

## Evaluating overall chatbot accuracy
- intent
- entity
- link (check status code)




