# N-gram Language Models

## Predicting the next word in a sentence
#### Example: Get probability of `house` given `This is a`.... -> Fourgram
**Process:**
1. Get a corpus

**This is a house**
The turtle is fat
*This is a turtle*
They lay on the ground
- 1 sentence has `house` given `This is a`
- 2 fourgrams in total have `This is a`
So `P(house|This is a) = 1/2`

#### Example: Get probability of `Jack` given `that`  -> Bigram
**Same process as above**:
This is a house 
This is a turtle
This is a house **that Jack** built 
They lay on the ground - 
The turtle is fat
*That lay* in the house **that Jack** built
- 2 sentences have `Jack` given `that`
- 3 bigrams in total have `That`
So `P(Jack|That) = 2/3` 

## Predicting probability of sequence of words

**Sequence of words** = (w1w2w3...)

## Bigram Language Model (n=2)
1. **P(Sequence of words)** = P(w<sub>1</sub>) P(w<sub>2</sub>|w<sub>1</sub>) ... P(w<sub>k</sub>|w<sub>k-1</sub>)
2. **P(Sequence of words)** = P(w<sub>1</sub>|start) P(w<sub>2</sub>|w<sub>1</sub>) ... P(w<sub>k</sub>|w<sub>k-1</sub>) P(end|w<sub>k</sub>)

#### Example:
**Corpus**:
This is the malt
That lay in the house that Jack build

**P(this is the house)**
= P(this) P(is|this) P(the|is) P(house|the)

|              | Simple/Bad Probability |
|--------------|------------------------|
| P(this)      | 1/2                    |
| P(is this)   | 1                      |
| P(the is)    | 1                      |
| P(house the) | 1/2                    |


**Note**: P(this) was not calculated like P(w<sub>1</sub>), it was rather calculated as P(w<sub>1</sub>|start) where start is equal to 2 since there are two ways to start the sentence

#### Question:
- Is this normalized for all sequence lengths? (i.e. Do they all add up to probability 1.0?)
- No! They are normalized for each sequence length.
  - P(this) + P(that) = 1.0
  - P(this this) + P(this is) + ... + P(built built) = 1.0















