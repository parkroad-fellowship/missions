## Global Failed Uploads Banner

The `GlobalFailedUploadsBanner` provides a global notification system that appears at the top of the app whenever there are failed recording uploads, regardless of which page the user is currently on.

### Features

1. **Global Visibility**: Shows at the top of the entire app, visible from any screen
2. **Real-time Updates**: Uses StreamBuilder to show live updates as uploads fail or succeed
3. **Quick Actions**: 
   - Retry all failed uploads with one tap
   - View detailed list of all failed uploads
   - Individual retry/remove actions for each upload
4. **Progress Feedback**: Shows loading states and success/error messages
5. **Session Information**: Displays which mission session each failed upload belongs to

### How it Works

#### Banner Display
- Appears at the top of the app when there are failed uploads
- Shows count of failed uploads
- Provides quick retry and view details buttons
- Disappears automatically when all uploads are successful

#### Global Retry
- Retry all failed uploads from anywhere in the app
- Shows progress indicator during retry
- Provides feedback on success/failure counts
- Continues retrying even if individual uploads fail

#### Detailed View
- Modal bottom sheet with complete list of failed uploads
- Shows session ULID for each upload to identify which mission session it belongs to
- Individual actions for each upload (retry/remove)
- Real-time updates as uploads succeed or fail
- Auto-closes when all uploads complete

#### Integration
The banner is integrated at the app root level in `PRFSuperApp`, wrapping the entire MaterialApp.router, ensuring it appears on every screen.

### Usage Examples

1. **User records audio in Mission Session A**: If upload fails, banner appears
2. **User navigates to Landing Page**: Banner still visible, can retry from there
3. **User goes to Mission Session B**: Can still see and retry uploads from Session A
4. **User taps banner**: Can retry all uploads or view details
5. **User taps "View Details"**: Sees which session each upload belongs to

This provides a seamless experience where users never lose track of failed uploads and can always retry them regardless of where they are in the app.
