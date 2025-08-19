using System.Text.Json.Serialization;

namespace GenAIAPP.API.Models
{
    public class OpenAiResponse
    {
        [JsonPropertyName("text")]
        public string Text { get; set; }
    }
}
