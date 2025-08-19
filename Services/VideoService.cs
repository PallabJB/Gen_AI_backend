using GenAIAPP.api.Services;
using GenAIAPP.API.Services;
using Xabe.FFmpeg;

namespace GenAIAPP.API.Services
{
    public class VideoService : IVideoService
    {
        private readonly IWhisperService _whisperService;

        public VideoService(IWhisperService whisperService, IConfiguration configuration)
        {
            _whisperService = whisperService;

            // Get FFmpeg path from configuration or environment variable
            var ffmpegPath = configuration["C:\\ffmpeg-7.1.1-essentials_build\\ffmpeg-7.1.1-essentials_build\\bin"]
                             ?? Environment.GetEnvironmentVariable("ffmpegPath");

            if (string.IsNullOrWhiteSpace(ffmpegPath) || !Directory.Exists(ffmpegPath))
            {
                throw new DirectoryNotFoundException(
                    "FFmpeg executables not found. Please set 'FFmpeg:Path' in configuration or add to PATH."
                );
            }

            FFmpeg.SetExecutablesPath(ffmpegPath);
        }

        public async Task<string> ExtractAudioAndTranscribeAsync(string videoPath)
        {
            try
            {
                var audioPath = Path.ChangeExtension(videoPath, ".mp3");

                var conversion = await FFmpeg.Conversions.FromSnippet.ExtractAudio(videoPath, audioPath);
                await conversion.Start();

                return await _whisperService.TranscribeAudioAsync(audioPath);
            }
            catch (Exception ex)
            {
                throw new ApplicationException($"Error extracting audio: {ex.Message}", ex);
            }
        }
    }
}
