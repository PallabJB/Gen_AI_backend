namespace GenAIAPP.api.Services
{
    public interface IWhisperService
    {
        Task<string> TranscribeAudioAsync(string filePath);
    }
}
