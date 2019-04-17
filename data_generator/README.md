This script is a piece of: https://github.com/gsssrao/youtube-8m-videos-frames

#### Download videos 

To download videos corresponding to the video-ids downloaded in the previous step.
```
bash downloadvideos.sh <number-of-videos> <category-name>
```

This downloads `<number-of-videos>` youtube videos corresponding to the `category-name` under the folder `videos`. If you want to download all the videos of the category specify `<number-of-videos>` as `0`

By default a video is downloaded in the best possible resolution. If you want to download only an `mp4` of a fixed resolution like `1280x720`, you can do this changing the value for `-f` modifier in `downloadvideos.sh` at line numbers `31` and `40` (`-f 22` stands for `mp4 1280x720` whereas `-f best` stands for best possible resolution). To list the types of formats supported refer this stackoverflow [question](https://askubuntu.com/questions/486297/how-to-select-video-quality-from-youtube-dl).

***Example usage***
```
bash downloadvideos.sh 10 The Walt Disney Company
```

This will download 10 videos of the `The Walt Disney Company` category in the `videos` folder.
