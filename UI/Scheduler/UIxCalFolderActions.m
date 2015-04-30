/*
  Copyright (C) 2006-2015 Inverse inc.
  Copyright (C) 2004-2005 SKYRIX Software AG

  This file is part of SOGo

  SOGo is free software; you can redistribute it and/or modify it under
  the terms of the GNU Lesser General Public License as published by the
  Free Software Foundation; either version 2, or (at your option) any
  later version.

  SOGo is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
  License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with OGo; see the file COPYING.  If not, write to the
  Free Software Foundation, 59 Temple Place - Suite 330, Boston, MA
  02111-1307, USA.
*/

#import <Foundation/NSValue.h>
#import <NGObjWeb/NSException+HTTP.h>
#import <NGObjWeb/WORequest.h>
#import <NGObjWeb/WOResponse.h>

#import <NGCards/iCalCalendar.h>

#import <SOGo/NSDictionary+Utilities.h>

#import <Appointments/SOGoAppointmentFolder.h>
#import <Appointments/SOGoWebAppointmentFolder.h>
#import <Appointments/SOGoAppointmentFolderICS.h>

#import "UIxCalFolderActions.h"

@implementation UIxCalFolderActions

- (WOResponse *) exportAction
{
  WOResponse *response;
  SOGoAppointmentFolderICS *folderICS;
  NSString *disposition;

  folderICS = [self clientObject];
  response = [self responseWithStatus: 200
                            andString: [folderICS contentAsString]];
  [response setHeader: @"text/calendar; charset=utf-8" 
               forKey: @"content-type"];
  disposition = [NSString stringWithFormat: @"attachment; filename=\"%@.ics\"",
                          [folderICS displayName]];
  [response setHeader: disposition forKey: @"Content-Disposition"];

  return response;
}

- (WOResponse *) importAction
{
  SOGoAppointmentFolder *folder;
  NSMutableDictionary *rc;
  iCalCalendar *additions;
  NSString *fileContent;
  WOResponse *response;
  WORequest *request;
  NSArray *cals;
  id data;

  int i, imported;

  imported = 0;
  rc = [NSMutableDictionary dictionary];
  request = [context request];
  folder = [self clientObject];
  data = [request formValueForKey: @"calendarFile"];
  if ([data respondsToSelector: @selector(isEqualToString:)])
    fileContent = (NSString *) data;
  else
    {
      fileContent = [[NSString alloc] initWithData: (NSData *) data 
                                          encoding: NSUTF8StringEncoding];
      if (fileContent == nil)
        fileContent = [[NSString alloc] initWithData: (NSData *) data 
                                            encoding: NSISOLatin1StringEncoding];
      [fileContent autorelease];
    }

  if (fileContent && [fileContent length] 
      && [fileContent hasPrefix: @"BEGIN:"])
    {
      cals = [iCalCalendar parseFromSource: fileContent];

      for (i = 0; i < [cals count]; i++)
        {
          additions = [cals objectAtIndex: i];
          imported += [folder importCalendar: additions];
        }
    }

  [rc setObject: [NSNumber numberWithInt: imported]
         forKey: @"imported"];

  response = [self responseWithStatus: 200];
  [response setHeader: @"text/html" 
               forKey: @"content-type"];
  [(WOResponse*)response appendContentString: [rc jsonRepresentation]];
  return response;
}

/* These methods are only available on instance of SOGoWebAppointmentFolder. */

/**
 * @api {get} /so/:username/Scheduler/:calendarId/reload Load Web calendar
 * @apiVersion 1.0.0
 * @apiName PostReloadWebCalendar
 * @apiGroup Calendar
 * @apiExample {curl} Example usage:
 *     curl -i http://localhost/SOGo/so/sogo1/Calendar/5B30-55419180-7-6B687280/reload
 *
 * @apiDescription Load and parse the events from a remote Web calendar (.ics)
 *
 * @apiSuccess (Success 200) {Number} status     The HTTP code received when accessing the remote URL
 * @apiSuccess (Success 200) {String} [imported] The number of imported events in case of success
 * @apiError   (Error 500)   {String} [error]    The error type in case of a failure
 */
- (WOResponse *) reloadAction
{
  NSDictionary *results;
  unsigned int httpCode;

  httpCode = 200;
  results = [[self clientObject] loadWebCalendar];

  if ([results objectForKey: @"error"])
    httpCode = 500;

  return [self responseWithStatus: httpCode andJSONRepresentation: results];
}

- (WOResponse *) setCredentialsAction
{
  WORequest *request;
  WOResponse *response;
  NSString *username, *password;

  request = [context request];

  username = [[request formValueForKey: @"username"] stringByTrimmingSpaces];
  password = [[request formValueForKey: @"password"] stringByTrimmingSpaces];
  if ([username length] > 0 && [password length] > 0)
    {
      [[self clientObject] setUsername: username
                           andPassword: password];
      response = [self responseWith204];
    }
  else
    response
      = (WOResponse *) [NSException exceptionWithHTTPStatus: 400
                                    reason: @"missing 'username' and/or"
                                    @" 'password' parameters"];

  return response;
}

@end /* UIxCalFolderActions */
