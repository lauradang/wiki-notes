# Papers Read

Tracking papers read with key takeaways. Each entry links to a deeper note.

## NLP

| Paper | Key insight | Deep dive |
|---|---|---|
| [Attention Is All You Need](https://arxiv.org/abs/1706.03762) | - Self-attention lets each token model relationships with all other tokens in the sequence, instead of relying on nearby context or a hidden state passed through RNN timesteps.<br>- This shortens the path for long-range dependencies, avoiding the RNN bottleneck where context can fade over many steps.<br>- Positional encoding adds word-order information, since attention alone does not know sequence order.<br>- Multi-head attention lets the model learn several relationship patterns in parallel.<br>- Transformer training can parallelize across sequence positions, though autoregressive generation still happens one token at a time. | [notes](attention-is-all-you-need.md) |
| [BERT: Pre-training of Deep Bidirectional Transformers](https://arxiv.org/abs/1810.04805) | Prior models were either bidirectional but shallow (ELMo) or deep but left-to-right only (GPT). BERT uses masked token prediction to get deep bidirectional context without cheating. One pre-trained model works across tasks — just swap the final output layer instead of building a new architecture per task | [notes](../LLMs/BERT.md) |
| [Language Models are Few-Shot Learners](https://arxiv.org/abs/2005.14165) | - GPT-3 performs well on many new tasks without task-specific fine-tuning.<br>- In-context learning uses zero-shot, one-shot, or few-shot prompting instead of changing model weights at inference time.<br>- This reduces the need for expensive per-task fine-tuning, but does not make fine-tuning irrelevant.<br>- Performance generally improves with parameter count, and larger models are better at using in-context examples.<br>- Few-shot usually outperforms zero-shot, though some tasks still struggle. | [notes](language-models-are-few-shot-learners.md) |

## CV

| Paper | Key insight | Deep dive |
|---|---|---|
| [CNNs for Automatic Image Colorization](https://pdfs.semanticscholar.org/5a71/e3ada938c6c45a87988670118291b3028df6.pdf) | Two-stage CNN on VGG-16 features to predict UV channels from grayscale; formulates colorization as regression with cross-entropy loss | [notes](Convolutional-Neural-Networks-for-automatic-image_colorization.md) |
| [Learning Representations for Automatic Colorization](https://arxiv.org/abs/1603.06668) | Predicts per-pixel color histograms via VGG-16 hypercolumns; KL-divergence loss handles multimodal color distributions that MSE can't | [notes](learning-representation-for-automatic-colorization.md) |
| [StackGAN](https://arxiv.org/abs/1612.03242) | Two-stage GAN for text-to-image — Stage-I generates low-res from text embeddings via conditioning augmentation, Stage-II refines to photo-realistic | [notes](StackGAN.md) |
| [Image Style Transfer (Gatys et al.)](https://www.cv-foundation.org/openaccess/content_cvpr_2016/papers/Gatys_Image_Style_Transfer_CVPR_2016_paper.pdf) | Separates content and style via VGG-19 feature maps and Gram matrices; optimizes a combined loss to merge content from one image with style from another | [notes](style-transfer.md) |
