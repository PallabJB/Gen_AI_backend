using System.Text.Json.Serialization;

namespace GenAIAPP.api.Models
{
    public class OpenAiResponse
    {
        [JsonPropertyName("text")]
        public string Text { get; set; }
    }
}
