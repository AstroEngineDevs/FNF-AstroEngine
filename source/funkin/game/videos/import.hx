package funkin.game.videos;


#if VIDEOS_ALLOWED
#if (hxCodec >= "2.6.1")
import hxcodec.VideoHandler as MP4Handler;
#elseif (hxCodec == "2.6.0")
import VideoHandler as MP4Handler;
#else
import vlc.MP4Handler;
#end
#end

using StringTools;