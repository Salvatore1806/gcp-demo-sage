"""Text embedding via Vertex AI."""

from google.genai import types

from sage.config import get_app_config
from sage.integrations.llm.client import get_genai_client


def embed_text(text: str) -> list[float]:
    config = get_app_config()
    client = get_genai_client()
    response = client.models.embed_content(
        model=config.embedding_model,
        contents=text,
        config=types.EmbedContentConfig(
            output_dimensionality=config.embedding_dimension
        ),
    )
    return list(response.embeddings[0].values)