# TensorFlow TPU Usage for Google Colab

```python
import tensorflow as tf

resolver = tf.distribute.cluster_resolver.TPUClusterResolver(tpu="grpc://" + os.environ["COLAB_TPU_ADDR"])
tf.config.experimental_connect_to_cluster(resolver)
tf.tpu.experimental.initialize_tpu_system(resolver)
strategy = tf.distribute.experimental.TPUStrategy(resolver)

...

with strategy.scope(): 
  model = create_model()
  model.compile(loss="categorical_crossentropy", optimizer="adam", metrics=["acc"])
```

