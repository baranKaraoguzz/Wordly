//
//  Downloader.swift
//  Wordly
//
//  Created by eposta developer on 15/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//
import CoreData
import Foundation
class Downloader : NSObject, NSURLSessionDownloadDelegate
{
    
    
    //is called once the download is complete
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL)
    {
        //copy downloaded data to your documents directory with same names as source file
        /*
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        let destinationUrl = documentsUrl!.URLByAppendingPathComponent(url!.lastPathComponent!)
        let dataFromURL = NSData(contentsOfURL: location)
        dataFromURL?.writeToURL(destinationUrl, atomically: true)
        let str = String(data: dataFromURL!, encoding: NSUTF8StringEncoding)
        
        //now it is time to do what is needed to be done after the download
        debugPrint( "Download \(str)") */
        /*
        switch entityType! {
        case .beginner :
            debugPrint("")
            self.counter += 1
            DatabaseUtil.deleteAllEntityData(.beginner)
            //DatabaseUtil2.removeAllEntityData(.beginner)
            let models : [WordTableModel] =  FileUtil.parseByteString(location)!
            debugPrint("model 0 : \(models[0])  model 1 : \(models[1])")
            self.modelsDict[.beginner] = models
            // DatabaseUtil.saveEntityData(.beginner, modelList: models)
            debugPrint("FINISHED FINISHED FINISHED beginner.")
        case .intermediate:
            self.counter += 1
            DatabaseUtil.deleteAllEntityData(.intermediate)
            let models : [WordTableModel] =  FileUtil.parseByteString(location)!
            debugPrint("model 0 : \(models[0])  model 1 : \(models[1])")
            self.modelsDict[.intermediate] = models
            // DatabaseUtil.saveEntityData(.intermediate, modelList: models)
            debugPrint("FINISHED FINISHED FINISHED intermediate.")
        case .advanced:
            self.counter += 1
            DatabaseUtil.deleteAllEntityData(.advanced)
            let models : [WordTableModel] =  FileUtil.parseByteString(location)!
            debugPrint("model 0 : \(models[0])  model 1 : \(models[1])")
            self.modelsDict[.advanced] = models
            // DatabaseUtil.saveEntityData(.advanced, modelList: models)
            debugPrint("FINISHED FINISHED FINISHED advanced.")
           
        }
         debugPrint("FINISHED FINISHED FINISHED ALL ALL ALL.")
 */
        self.modelsDict =  FileUtil.parseByteModelList(location)
        // delete
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            debugPrint(self.logTag + "word lists is being removed from database.")
            DatabaseUtil.deleteAllEntityData(.beginner)
            DatabaseUtil.deleteAllEntityData(.intermediate)
            DatabaseUtil.deleteAllEntityData(.advanced)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                debugPrint("DISPATCH_QUEUE delete")
            })
        });
       
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), { () -> Void in
            
            if self.downloaderDelegate != nil {
                debugPrint("NOTNIL  NOTNIL NOTNIL NOTNIL.")
                self.downloaderDelegate!.getDownloadedWordsDict(self.modelsDict)
            }
            
        })
        

    }
    
    //this is to track progress
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
    }
    
    // if there is an error during download this will be called
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        if(error != nil)
        {
            //handle the error
            debugPrint(self.logTag + "Download completed with error: \(error!.localizedDescription)");
        }
    }
    
    //method to be called to download
    func downloadWordList(type : EntityName)
    {
        self.entityType = type
        
        switch entityType! {
        case .beginner :
            debugPrint("")
            let urlString : String = HttpLink.HTTP_LINK + HttpLink.WORD_LIST_CSV_BEGINNER
             self.url = NSURL(string: urlString)
        case .intermediate:
            debugPrint("")
            let urlString : String = HttpLink.HTTP_LINK + HttpLink.WORD_LIST_CSV_INTERMEDIATE
            self.url = NSURL(string: urlString)
        case .advanced:
            debugPrint("")
            let urlString : String = HttpLink.HTTP_LINK + HttpLink.WORD_LIST_CSV_ADVANCED
            self.url = NSURL(string: urlString)
        }
      
        
        //download identifier can be customized. I used the "ulr.absoluteString"
        let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(url!.absoluteString!)
        let session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithURL(url!)
        task.resume()
    }
    
    func downloadAllWordList()
    {
        let urlString : String = HttpLink.HTTP_LINK + HttpLink.WORD_LIST_CSV
        self.url = NSURL(string: urlString)
        
        //download identifier can be customized. I used the "ulr.absoluteString"
        let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(url!.absoluteString!)
        let session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithURL(url!)
        task.resume()
    }
    
    func downloadBeginner(){
        
        let urlString : String = HttpLink.HTTP_LINK + HttpLink.WORD_LIST_CSV_BEGINNER
        self.url = NSURL(string: urlString)
        
        //download identifier can be customized. I used the "ulr.absoluteString"
        let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(url!.absoluteString!)
        let session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithURL(url!)
        task.resume()
    
    }
    

    
    //# MARK: - Class Variables / Members / Constructors
    weak  var  downloaderDelegate   = DownloaderDelegate?()
    var url : NSURL?
   private let logTag = "Downloader "
    // will be used to do whatever is needed once download is complete
    var entityType : EntityName?
  
    var modelsDict = [EntityName:[WordTableModel]]()
    override init(){}
  


}
