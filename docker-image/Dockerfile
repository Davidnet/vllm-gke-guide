FROM nvcr.io/nvidia/pytorch:23.10-py3
RUN python -m pip install vllm --extra-index-url https://download.pytorch.org/whl/cu128
RUN python -m pip install numpy==1.26.4
# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Give execution rights to the entrypoint script
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["python", "-m", "vllm.entrypoints.openai.api_server", \
     "--host=0.0.0.0", \
     "--port=8000", \
     "--model=google/gemma-3n-e2b-it", \
     "--download-dir=/data", \
     "--tensor_parallel_size=1", \
     "--max-model-len=2048", \
     "--enforce-eager"]
