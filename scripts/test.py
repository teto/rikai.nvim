from kokoro import KPipeline
import soundfile as sf
import torch
pipeline = KPipeline(lang_code='j')
text_en = '''
kokoro is an open-weight TTS model with 82 million parameters. Despite its lightweight architecture, it delivers comparable quality to larger models while being significantly faster and more cost-efficient. With Apache-licensed weights, [Kokoro](/kˈOkəɹO/) can be deployed anywhere from production environments to personal projects.
'''
text_jap = "暑さで具合が悪くなった外国人が病院にたくさん来ている"
text = text_jap

# speed is 1 by default
generator = pipeline(text, voice='af_heart', speed=0.8)
for i, (gs, ps, audio) in enumerate(generator):
    print(i, gs, ps)
    sf.write(f'{i}.wav', audio, 24000)
