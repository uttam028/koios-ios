1. RATING
This is scrollable list of numeric options. This was my initial solution to the problem of rating your experience from 1-10. It is more compact for rating something.

2. NUMERIC
This is for users to enter a number to a question (e.g how many times have you done this? How many days since? etc.) 

3. PHOTO
This allows the users to submit a photo from their camera roll to the server. I set it up such that it will auto-resize the photo to fit within the screen so they can see the photo they choose to submit. I did leave the function that actually sends the photo to the server and the delegate function blank because I did not know if it should be the same as how the recording feature uploads to the server

4. LIKERT
The Likert scale is a scale that allows the user to rate their experience along a scale (See https://en.wikipedia.org/wiki/Likert_scale). Dr. Poellabauer had me make a 4-pt, 5-pt, and 7-pt scale. The user would theoretically add options for the scale but also can select to use the preset (i.e standard) options. In addition, the user can select to use a legend that shows numbers instead of the actual options themselves in order to save space (there is a key below the question).

5. PAUSE ACTIVITY BUTTON
At Dr. Poellabauer's request, I added a toggle button in the profile page that allows the user to pause all activity (currently does nothing when set to on). This would remove all surveys and not ask them to do tasks, as well as stop notificaitons.
