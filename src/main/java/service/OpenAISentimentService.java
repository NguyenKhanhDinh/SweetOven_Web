package service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import okhttp3.*;
import org.json.JSONObject;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

public class OpenAISentimentService {

    private static final String API_KEY = System.getenv("OPENAI_API_KEY");
    private static final String API_URL = "https://api.openai.com/v1/chat/completions";
    private static final OkHttpClient client = new OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .build();

    public String analyzeSentiment(String content) {
        if (API_KEY == null || API_KEY.isEmpty()) {
            System.err.println("OPENAI_API_KEY not found in environment variables");
            return "NEUTRAL"; // Default fallback
        }

        if (content == null || content.trim().isEmpty()) {
            return "NEUTRAL";
        }

        String prompt = buildPrompt(content);

        try {
            String response = callOpenAI(prompt);
            return extractSentiment(response);
        } catch (IOException e) {
            System.err.println("OpenAI API call failed: " + e.getMessage());
            return "NEUTRAL"; // Fallback on error
        }
    }
    private String buildPrompt(String content) {

        return """
        Bạn là AI phân loại cảm xúc feedback khách hàng.

        Nhiệm vụ:
        Chỉ phân loại feedback thành DUY NHẤT 1 trong 4 nhãn sau:

        POSITIVE
        NEUTRAL
        NEGATIVE
        BLOCKED

        Quy tắc:
        - POSITIVE:
          Khách hàng khen, hài lòng, đánh giá tốt, muốn quay lại.

        - NEUTRAL:
          Nội dung bình thường, không rõ tích cực hay tiêu cực.

        - NEGATIVE:
          Phàn nàn, chê, không hài lòng, trải nghiệm tệ.

        - BLOCKED:
          Spam, quảng cáo, chửi tục, toxic, xúc phạm.

        QUAN TRỌNG:
        - Chỉ được trả về đúng 1 từ.
        - Không giải thích.
        - Không thêm ký tự khác.
        - Không xuống dòng.

        Feedback:
        "%s"
        """.formatted(content);
    }


    private String callOpenAI(String prompt) throws IOException {
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-4o-mini");
        requestBody.put("temperature", 0.3);
        requestBody.put("max_tokens", 50);

        JSONObject message = new JSONObject();
        message.put("role", "user");
        message.put("content", prompt);
        requestBody.append("messages", message);

        Request request = new Request.Builder()
                .url(API_URL)
                .addHeader("Authorization", "Bearer " + API_KEY)
                .addHeader("Content-Type", "application/json")
                .post(RequestBody.create(
                        requestBody.toString(),
                        MediaType.parse("application/json")
                ))
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected code " + response);
            }

            String responseBody = response.body().string();
            JsonObject jsonObject = JsonParser.parseString(responseBody).getAsJsonObject();
            String sentiment = jsonObject
                    .getAsJsonArray("choices")
                    .get(0)
                    .getAsJsonObject()
                    .getAsJsonObject("message")
                    .get("content")
                    .getAsString()
                    .trim()
                    .toUpperCase();

            // Validate sentiment
            if (sentiment.equals("POSITIVE") || sentiment.equals("NEUTRAL") ||
                    sentiment.equals("NEGATIVE") || sentiment.equals("BLOCKED")) {
                return sentiment;
            }
            return "NEUTRAL";
        }
    }

    private String extractSentiment(String response) {
        if (response == null) return "NEUTRAL";

        if (response.contains("POSITIVE")) return "POSITIVE";
        if (response.contains("NEGATIVE")) return "NEGATIVE";
        if (response.contains("BLOCKED")) return "BLOCKED";
        return "NEUTRAL";
    }
}