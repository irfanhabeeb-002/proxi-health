# App Icon Instructions

To create the Proxi Health app icon:

1. Create a 512x512 PNG image with the following design:
   - Background: Gradient from #1A2332 (dark blue) to #1E3A8A (blue) to #06B6D4 (cyan)
   - Two overlapping circles forming a heart shape:
     - Left circle: #1E3A8A (blue)
     - Right circle: #06B6D4 (cyan)
   - Bottom triangle completing the heart: #06B6D4 (cyan)
   - White plus sign (+) overlay in the center
   - Rounded corners (20% of width)

2. Save as `app_icon.png` in this directory

3. Run the following command to generate all platform icons:
   ```
   flutter pub run flutter_launcher_icons:main
   ```

The icon represents health (heart) + medical care (plus sign) in Proxi Health brand colors.