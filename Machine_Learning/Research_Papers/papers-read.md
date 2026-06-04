# Papers Read

Tracking papers read with key takeaways. Each entry links to a deeper note.

## NLP

| Paper | Year | Key insight | Deep dive |
|---|---|---|---|
| [BERT: Pre-training of Deep Bidirectional Transformers](https://arxiv.org/abs/1810.04805) | 2018 | Prior models were either bidirectional but shallow (ELMo) or deep but left-to-right only (GPT). BERT uses masked token prediction to get deep bidirectional context without cheating. One pre-trained model works across tasks — just swap the final output layer instead of building a new architecture per task | [notes](../LLMs/BERT.md) |

## CV

| Paper | Year | Key insight | Deep dive |
|---|---|---|---|
| [CNNs for Automatic Image Colorization](https://pdfs.semanticscholar.org/5a71/e3ada938c6c45a87988670118291b3028df6.pdf) | 2016 | Two-stage CNN on VGG-16 features to predict UV channels from grayscale; formulates colorization as regression with cross-entropy loss | [notes](Convolutional-Neural-Networks-for-automatic-image_colorization.md) |
| [Learning Representations for Automatic Colorization](https://arxiv.org/abs/1603.06668) | 2016 | Predicts per-pixel color histograms via VGG-16 hypercolumns; KL-divergence loss handles multimodal color distributions that MSE can't | [notes](learning-representation-for-automatic-colorization.md) |
| [StackGAN](https://arxiv.org/abs/1612.03242) | 2017 | Two-stage GAN for text-to-image — Stage-I generates low-res from text embeddings via conditioning augmentation, Stage-II refines to photo-realistic | [notes](StackGAN.md) |
| [Image Style Transfer (Gatys et al.)](https://www.cv-foundation.org/openaccess/content_cvpr_2016/papers/Gatys_Image_Style_Transfer_CVPR_2016_paper.pdf) | 2016 | Separates content and style via VGG-19 feature maps and Gram matrices; optimizes a combined loss to merge content from one image with style from another | [notes](style-transfer.md) |
