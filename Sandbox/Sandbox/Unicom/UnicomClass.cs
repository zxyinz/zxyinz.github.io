using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Sandbox.Unicom
{
    public class ResDesc
    {
        public int ID;
        public string strName;
        public int Type;
        public string strURL;
        public string strDesc;
        public DateTime CreateTime;
        public DateTime ExpireTime;
        public int AccCode;
        public int MoreAttribute;
    }

    public class KDB
    {
        public string m_strKDBPath;

        public KDB();
        public ~KDB();

        public int iCreateRes(ResDesc Desc);
        public bool iReleaseRes(LinkedList<int> ID);

        public int iUpdateResDesc(int ID, ResDesc Desc);

        public LinkedList<int> iGetResourceList();

        public LinkedList<int> iFiliterBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string,string>> CmdPair);
   
        public ResDesc iGetDesc(int ID, int AccCode);

        public LinkedList<int> iGetRecommendList(int UserID);

    }

    public class RewardDesc
    {
        public int RewardID;
        public int Account;
        public int Credit;
        public string strMessage;
        public int Status;
        public DateTime TimeStamp;
        public int AttachResID;
    }

    public class RewardManager
    {
        public string m_strTablePath;
        public int m_BaseLine;

        public RewardManager();
        public ~RewardManager();

        public int iReportReward(RewardDesc Desc);
        public void iDeleteReward(int ID);
        public void iUpdateRewardStatus(int RewardID, int HRID);

        public int iUpdateBaseLine(int HRID);
        public int iGetBaseLine();

        public LinkedList<KeyValuePair<string, int>> iGetRewardActionList();

        public LinkedList<int> iGetRewardList();
        public LinkedList<int> iFiliterBySQL(LinkedList<int> RewardList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public RewardDesc iGetRewardDesc(int UserID);

        public LinkedList<int> iImportRewardLog(LinkedList<RewardDesc> RewardList);
        public string iExportRewardLog(LinkedList<int> RewardList)
        {
            string strLog = "";

            SystemManager SysManage = new SystemManager();
            PaperInstance Instance = new PaperInstance();
            SqlConnection connection = SysManage.iConnectDB();

            try{connection.Open();} catch(Exception ex) {/*...*/}

            try
            {
                //Get record list
                const string strCmd = "select [Account], [ActionName], Reward_AssignTable.[Credit], [Message], [TimeStamp] from" +
                                            "(Reward_RuleTable left join Reward_AssignTable on Reward_RuleTable.ID = Reward_AssignTable.Reward_ID)" +
								            "left join Sys_AccountTable on Reward_AssignTable.Account_ID = Sys_AccountTable.ID" + "order by Sys_AccountTable.ID";

                SqlCommand cmd = new SqlCommand(strCmd, connection);
                SqlDataReader dataReader = cmd.ExecuteReader();

                while(dataReader.Read())
                {
                    string strRecord = "";

                    //Write record;
                    //...

                    strLog = strLog + strRecord + "\r\n";
                }

                dataReader.Close();
                cmd.Dispose();

                SysManage.WriteLog(0, 20, 0, "Export Reward Log");
            }
            catch (Exception ex)
            {
                //...
            }

            //Close DB
            try { connection.Close(); } catch(Exception ex) {/*...*/}

            return strLog;
        }
    }

    public class Statistics
    {
        public Statistics();
        public ~Statistics();

        public LinkedList<string> iGenerateSystemRecord(string strFiliterString);
        public LinkedList<string> iGenerateRewardRecord(string strFiliterString);
        public LinkedList<string> iGenerateTrainingRecord(string strFiliterString);
        public LinkedList<string> iGenerateCourseRecord(string strFiliterString);

        public bool iExportRecordToFile(string strFilePath, LinkedList<string> List);
    }

    public class QuestionDesc
    {
        public int ID;
        public int CreaterID;
        public int Type;
        public float Score;
        public string strContent;
        public string strAnswer;
    }

    public class PaperDesc
    {
        public int ID;
        public string Name;
        public string Desc;
        public float Score;
        public int Level;
        public int CreaterID;
        public LinkedList<int> QuestionList;

        //For instance use
        public DateTime StartTime;
        public DateTime ExpireTime;
        public DateTime Duration;

        public bool bPrivate;
    }

    public class RegisteDesc
    {
        public int User;
        public int InstanceID;
        public int CourseID;
        public int Reviewer;
        public float Score;
        public DateTime StartTime;
        public DateTime SubmitTime;
    }

    public class PaperInstance
    {
        public int ID;
        public PaperDesc Desc;
        public RegisteDesc RegDesc;
        public LinkedList<KeyValuePair<QuestionDesc, string>> QuestionList;

        public int CurrentQuestionID;

        public PaperInstance();
        public ~PaperInstance();


        void iStartExam();
        void iSubmit();
        void iPause();

        DateTime iGetTimeCost();
        DateTime iGetTimeLeft();

        LinkedList<QuestionDesc> iGetQuestionList(int Start, int Number);

        void iUploadAnswer(int Start, LinkedList<string> AnswerList);

        void iEvaluate();

    }

    public class TestManager
    {
        public string m_strTablePath;

        public TestManager();
        public ~TestManager();

        //Question
        public int iCreateQuestion(QuestionDesc Desc, int CreaterID);
        public int iDeleteQuestion(int ID, int CreaterID);
        public int iUpdateQuestion(QuestionDesc Desc, int CreaterID);

        public LinkedList<int> iGetQuestionList();

        public LinkedList<int> iFiliterQuestionBySQL(LinkedList<int> QuestionList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public QuestionDesc iGetQuestionDesc(int ID);

        //Paper
        public int iCreatePaper(PaperDesc Desc, int CreaterID);
        public int iDeletePaper(int CreaterID);
        public int iUpdatePaper(PaperDesc Desc, int CreaterID);

        public LinkedList<int> iGetPaperList();

        public LinkedList<int> iFiliterPaperBySQL(LinkedList<int> PaperList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public PaperDesc iGetPaperDesc(int ID);

        //Instance instance
        public int iCreateInstance(PaperDesc InstanceDesc, int CreaterID);
        public int iDeleteInstance(int CreaterID);
        public int iUpdateInstance(PaperDesc InstanceDesc, int CreaterID);

        public LinkedList<int> iGetInstanceList();

        public LinkedList<int> iFiliterInstanceBySQL(LinkedList<int> InstanceList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public PaperInstance iGetInstance(int ID)
        {
            SystemManager SysManage = new SystemManager();
            PaperInstance Instance = new PaperInstance();
            SqlConnection connection = SysManage.iConnectDB();

            try{connection.Open();} catch(Exception ex) {/*...*/}

            try
            {
                //Get instance info
                SqlCommand cmd = new SqlCommand("select * from  Exam_InstanceTable join Exam_PaperDescTable on (Exam_InstanceTable.Paper_ID = Exam_PaperDescTable.ID) where Exam_InstanceTable.ID =" + ID, connection);
                SqlDataReader dataReader = cmd.ExecuteReader();

                bool bSuccess = dataReader.Read();

                if (bSuccess)
                {
                    //File Instance.RegDesc and Instance.Desc
                    //...
                    SysManage.WriteLog(0, 10, 0, "Get exam instance, Successful");
                }
                else
                {
                    SysManage.WriteLog(0, 10, 1, "Get exam instance, failed");
                }

                dataReader.Close();
                cmd.Dispose();
            }
            catch (Exception ex)
            {
                //...
            }

            try
            {
                //Get question list
                const string strQuestionSQL = "select [Type], [Content], [Answer], [Score] from" +
                                        "(Exam_QuestionTable	left join Exam_PaperInfoTable on Exam_QuestionTable.ID = Exam_PaperInfoTable.Question_ID)" +
                                        "left join Exam_InstanceTable on Exam_PaperInfoTable.Paper_ID = Exam_InstanceTable.Paper_ID" + "where Exam_InstanceTable.ID";

                SqlCommand cmd = new SqlCommand(strQuestionSQL + ID, connection);
                SqlDataReader dataReader = cmd.ExecuteReader();

                while(dataReader.Read())
                {
                    KeyValuePair<QuestionDesc,string> QuestionPair = new KeyValuePair<QuestionDesc,string>();

                    //File Instance.QuestionList
                    //...

                    Instance.QuestionList.AddLast(QuestionPair);
                }

                dataReader.Close();
                cmd.Dispose();
            }
            catch (Exception ex)
            {
                //...
            }

            //Close DB
            try { connection.Close(); } catch(Exception ex) {/*...*/}

            return Instance;
        }

        // User Registration
        public int iRegisteExam(RegisteDesc Desc);
        public bool iUnRegisteExam(int RegID);
        public int iUpdateRegDesc(int RegID, RegisteDesc Desc);

        public LinkedList<int> iGetRegList();

        public LinkedList<int> iFiliterRegBySQL(LinkedList<int> RegList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public RegisteDesc iGetRegDesc(int ID);
    }

    public class LabDesc : PaperDesc
    {
        public string strContent;
    }

    public class LabInstance
    {
        public int ID;
        public LabDesc Desc;
        public RegisteDesc RegDesc; //Use exam

        public LabInstance();
        public ~LabInstance();

        void iStart();
        void iSubmit();
        void iPause();

        DateTime iGetTimeCost();
        DateTime iGetTimeLeft();

        void iUploadAnswer(int Start, LinkedList<string> AnswerList);

        void iEvaluate();
    }

    public class LabManager
    {
        public string m_strTablePath;

        public LabManager();
        public ~LabManager();

        //Lab instance
        public int iCreateLab(LabDesc LabDesc, int CreaterID);
        public int iDeleteLab(int CreaterID);
        public int iUpdateLab(LabDesc LabDesc, int CreaterID);

        public LinkedList<int> iGetLabList();

        public LinkedList<int> iFiliterLabBySQL(LinkedList<int> LabList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public LabDesc iGetLabDesc(int ID);

        // User Registration
        public int iRegisteLab(RegisteDesc Desc);
        public bool iUnRegisteLab(int RegID);
        public int iUpdateRegDesc(int RegID, RegisteDesc Desc);

        public LinkedList<int> iGetRegList();

        public LinkedList<int> iFiliterRegBySQL(LinkedList<int> RegList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public RegisteDesc iGetRegDesc(int ID);
    }

    
    public class CourseDesc
    {
        public int ID;
        public string Name;
        public string Desc;
        public int CreaterID;
        public DateTime CreateTime;
        public DateTime ExpireTime;
        public int Category;
        public int Department;
        public int SectionType;
        public int CourseHour;
        public int Credit;
        public string LEcturer;
    }

    public class CourseResDesc
    {
        public int ID;
        public int CourseID;
        public int Type;
        public int ResID;
        public DateTime AddTime;
        public bool Assignment;
    }

    public class CourseRegisteDesc : RegisteDesc
    {
        public int Progress;
        public int Credict;
    }

    public class CourseManager
    {
        public string m_strTablePath;

        public CourseManager();
        public ~CourseManager();

        //Course
        public int iAddCourse(int CourseID, CourseDesc Desc, int CreaterID);
        public int iDeleteCourse(int CourseID, int CreaterID);
        public int iUpdateCourse(int CourseID, CourseDesc Desc, int CreaterID);

        public LinkedList<int> iGetCourseList();

        public LinkedList<int> iFiliterCourseBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public CourseDesc iGetCourseDesc(int ID);

        //Resource
        public int iAddResources(int CourseID, CourseResDesc Desc, int CreaterID);
        public int iDeleteResources(int CourseID, int CreaterID);
        public int iUpdateResources(int CourseID, CourseResDesc Desc, int CreaterID);

        public LinkedList<int> iGetResList();

        public LinkedList<int> iFiliterResBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public CourseResDesc iGetRegDesc(int CourseID, int ID);

        // User Registration
        public int iRegisteCourse(CourseRegisteDesc Desc);
        public bool iUnRegisteCourse(int RegID);
        public int iUpdateRegDesc(int RegID, CourseRegisteDesc Desc);

        public LinkedList<int> iGetRegList();

        public LinkedList<int> iFiliterRegBySQL(LinkedList<int> RegList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public CourseRegisteDesc iGetRegDesc(int ID);
    }

    public class SystemManager
    {
        public SystemManager();
        public ~SystemManager();

        //Account
        public SqlConnection iConnectDB()
        {
            const string strServerName = "LocalDBServer";
            const string strDBName = "UnicomTrainSysDB";
            const string strUser = "Admin";
            const string strPassword = "Password";

            string connetionString = "Data Source = " + strServerName + "; Initial Catalog = " + strDBName + ";User ID=" + strUser + ";Password=" + strPassword;
            
            return new SqlConnection(connetionString);
        }

        public int Login(string strAccount, string strPassword)
        {   
            SqlConnection connection = iConnectDB();
            int ID = -1;

            try
            {
                connection.Open();

                string strSQL = "select [ID], [Password] from Sys_AccountTable where [Account] like '" + strAccount + "'and [Password] = HASHBYTES('SHA2_512','" + strPassword + "')";

                SqlCommand command = new SqlCommand(strSQL, connection);
                SqlDataReader dataReader = command.ExecuteReader();

                bool bSuccess = dataReader.Read();

                if (bSuccess)
                {
                    ID = dataReader.GetInt32(0);
                    WriteLog(ID, 1, 0, "User Login, Successful");
                }
                else
                {
                    WriteLog(ID, 1, 1, "User Login, Failed");
                }

                dataReader.Close();
                command.Dispose();
                connection.Close();
            }
            catch (Exception ex)
            {
                //...
            }

            return ID;
        }

        public int Logout(int AccountID);
        public int ChangePassword(int AccountID);
        public int RegisteAccount(string strAccount, string strPassword, string strUserInfoJSON);
        public int UpdateAccount(int AccountID, string strInfoJSON);
        public LinkedList<string> iFiliterAccountBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);
        public LinkedList<string> iFiliterAccountInfoBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);

        //Log
        public int WriteLog(int Account, int Action, int Code, string strMessage);
        public LinkedList<string> iFiliterLogBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);

        //Constant
        public int iCreateConstant(int Key, string strValue, string strDesc);
        public int iDeleteConstant(int Key);
        public LinkedList<string> iFiliterConstantBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);

        //Rule
        public int CreateRuleList(int ID, LinkedList<int> RuleID);
        public int DeleteRuleList(int ID, LinkedList<int> RuleID);
        public int AssignRuleList(int ID, int AccountID);

        public LinkedList<int> iFiliterRuleBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);
        public LinkedList<int> iFiliterRuleListBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);
    }

    public class PlanDesc
    {
        public int ID;
        public string strName;
        public int HolderID;
        public string strDesc;
        public DateTime CreateTime;
        public DateTime ExpireTime;
        public int AccCode;
        public int MoreAttribute;
        public int Status;
        public int MoreAttributes;
    }

    public class ClassDesc : PlanDesc
    {
        public int CourseID;
        public bool ClassType;
        public DateTime CheckInTime;
        public int Cost;
        public string strRequirement;
        public string strMemo;
        public int MoreAttributes;
    }

    public class ClassRegisteDesc : CourseRegisteDesc
    {
        int ClassID;
        DateTime RegisteTime;
        int QuestionnaireID;
    }

    public class TrainingManager
    {
        public string m_strPath;

        public TrainingManager();
        public ~TrainingManager();

        //Plan
        public int iCreatePlan(PlanDesc Desc);
        public bool iDeletePlan(int PlanID);
        public int iUpdatePlanDesc(int ID, PlanDesc Desc);

        public LinkedList<int> iGetPlanList();
        public LinkedList<int> iFiliterPlanBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);
        public PlanDesc iGetPlanDesc(int ID);

        //Class
        public int iCreateClass(int PlanID, ClassDesc Desc);
        public bool iDeleteClass(int ClassID);
        public int iUpdateClassDesc(int ID, ClassDesc Desc);

        public LinkedList<int> iGetClassList();
        public LinkedList<int> iFiliterClassBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);
        public ClassDesc iGetClassDesc(int ID);

        //Lecturer
        public int iCreateLecturer(int LecturerID, string strName);
        public bool iDeleteLecturer(int LecturerID);
        public int iUpdateLecturerDesc(int LecturerID, string strName);

        public LinkedList<int> iGetLecturerList();
        public LinkedList<int> iFiliterLecturerBySQL(LinkedList<int> ResList, LinkedList<KeyValuePair<string, string>> CmdPair);
        public string iGetLecturerDesc(int ID);

        // User Registration
        public int iRegisteCourse(ClassRegisteDesc Desc);
        public bool iUnRegisteCourse(int RegID);
        public int iUpdateRegDesc(int RegID, ClassRegisteDesc Desc);

        public LinkedList<int> iGetRegList();

        public LinkedList<int> iFiliterRegBySQL(LinkedList<int> RegList, LinkedList<KeyValuePair<string, string>> CmdPair);

        public ClassRegisteDesc iGetRegDesc(int ID);
    }
}