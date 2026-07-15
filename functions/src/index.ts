import OpenAI from "openai";
import {defineSecret} from "firebase-functions/params";
import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

const allowedMimeTypes = [
  "image/jpeg",
  "image/png",
  "image/webp",
];

const prompt = [
  "You are GlowMatch, a cosmetic color and hairstyle assistant.",
  "",
  "Analyze only clearly visible appearance details in the photo.",
  "Never identify the person.",
  "Never infer age, ethnicity, health, medical conditions,",
  "personality, or other sensitive traits.",
  "Do not diagnose skin conditions.",
  "",
  "A photograph cannot reliably determine actual skin type.",
  "For skinType, return:",
  "\"Fotoğraftan güvenilir biçimde belirlenemez\".",
  "",
  "Lighting, filters, makeup, and camera quality may affect results.",
  "If any feature is unclear, return \"Belirsiz\".",
  "",
  "Return all values in Turkish.",
  "",
  "Analyze:",
  "- visible overall skin-tone family",
  "- likely undertone",
  "- visible face-shape family",
  "- visible eye-color family",
  "- visible hair-color family",
  "- suitable foundation color family",
  "- suitable concealer color family",
  "- suitable blush color family",
  "- suitable lipstick color family",
  "- suitable hairstyle",
  "- suitable hair-color family",
  "",
  "Commercial products and shade codes are suggestions only.",
  "Do not invent an exact shade code.",
  "When uncertain, use \"Mağazada doğrulanmalı\".",
].join("\n");

export const analyzeFace = onRequest(
  {
    secrets: [OPENAI_API_KEY],
    cors: true,
    timeoutSeconds: 120,
    memory: "1GiB",
    maxInstances: 5,
  },
  async (req, res) => {
    try {
      if (req.method !== "POST") {
        res.status(405).json({
          error: "Yalnızca POST isteğine izin verilir.",
        });
        return;
      }

      const requestBody =
        req.body && typeof req.body === "object" ?
          req.body as Record<string, unknown> :
          {};

      const receivedImage = requestBody.image;
      const receivedMimeType = requestBody.mimeType;

      if (typeof receivedImage !== "string") {
        res.status(400).json({
          error: "Fotoğraf verisi gönderilmedi.",
        });
        return;
      }

      const mimeType =
        typeof receivedMimeType === "string" ?
          receivedMimeType :
          "image/jpeg";

      if (!allowedMimeTypes.includes(mimeType)) {
        res.status(400).json({
          error: "Yalnızca JPEG, PNG ve WEBP desteklenir.",
        });
        return;
      }

      const image = receivedImage.includes(",") ?
        receivedImage.substring(receivedImage.indexOf(",") + 1) :
        receivedImage;

      if (!image || !/^[A-Za-z0-9+/=]+$/.test(image)) {
        res.status(400).json({
          error: "Geçerli bir Base64 fotoğraf gönderilmedi.",
        });
        return;
      }

      if (image.length > 20_000_000) {
        res.status(413).json({
          error: "Fotoğraf çok büyük. Daha küçük bir fotoğraf seçin.",
        });
        return;
      }

      const apiKey = OPENAI_API_KEY.value();

      if (!apiKey) {
        logger.error("OPENAI_API_KEY secret is unavailable.");

        res.status(500).json({
          error: "Yapay zekâ servisi yapılandırılmamış.",
        });
        return;
      }

      const openai = new OpenAI({
        apiKey,
      });

      const response = await openai.responses.create({
        model: "gpt-5.6",
        input: [
          {
            role: "user",
            content: [
              {
                type: "input_text",
                text: prompt,
              },
              {
                type: "input_image",
                image_url: `data:${mimeType};base64,${image}`,
                detail: "high",
              },
            ],
          },
        ],
        max_output_tokens: 1500,
        text: {
          format: {
            type: "json_schema",
            name: "glowmatch_analysis",
            strict: true,
            schema: {
              type: "object",
              additionalProperties: false,
              properties: {
                skinTone: {
                  type: "string",
                },
                undertone: {
                  type: "string",
                },
                skinType: {
                  type: "string",
                },
                faceShape: {
                  type: "string",
                },
                eyeColor: {
                  type: "string",
                },
                hairColor: {
                  type: "string",
                },
                foundationBrand: {
                  type: "string",
                },
                foundationCode: {
                  type: "string",
                },
                concealerBrand: {
                  type: "string",
                },
                concealerCode: {
                  type: "string",
                },
                blushBrand: {
                  type: "string",
                },
                blushCode: {
                  type: "string",
                },
                lipstickBrand: {
                  type: "string",
                },
                lipstickCode: {
                  type: "string",
                },
                hairStyle: {
                  type: "string",
                },
                hairColorSuggestion: {
                  type: "string",
                },
                disclaimer: {
                  type: "string",
                },
              },
              required: [
                "skinTone",
                "undertone",
                "skinType",
                "faceShape",
                "eyeColor",
                "hairColor",
                "foundationBrand",
                "foundationCode",
                "concealerBrand",
                "concealerCode",
                "blushBrand",
                "blushCode",
                "lipstickBrand",
                "lipstickCode",
                "hairStyle",
                "hairColorSuggestion",
                "disclaimer",
              ],
            },
          },
        },
      });

      const outputText = response.output_text;

      if (!outputText) {
        throw new Error("OpenAI boş bir yanıt döndürdü.");
      }

      let analysisResult: Record<string, unknown>;

      try {
        analysisResult =
          JSON.parse(outputText) as Record<string, unknown>;
      } catch (parseError) {
        logger.error("OpenAI JSON parse error.", {
          responseId: response.id,
          parseError,
        });

        throw new Error("OpenAI yanıtı okunamadı.");
      }

      logger.info("GlowMatch analysis completed.", {
        responseId: response.id,
        model: "gpt-5.6",
      });

      res.status(200).json(analysisResult);
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ?
          error.message :
          "Bilinmeyen sunucu hatası.";

      logger.error("GlowMatch analysis failed.", {
        message: errorMessage,
      });

      res.status(500).json({
        error: "Fotoğraf analizi tamamlanamadı.",
        details: errorMessage,
      });
    }
  },
);
