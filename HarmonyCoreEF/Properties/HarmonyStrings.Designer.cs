// <auto-generated />

using System;
using System.Reflection;
using System.Resources;
using JetBrains.Annotations;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Logging;

namespace Harmony.Core.EF.Properties
{
    /// <summary>
    ///		This API supports the Entity Framework Core infrastructure and is not intended to be used
    ///     directly from your code. This API may change or be removed in future releases.
    /// </summary>
    public static class HarmonyStrings
    {
        private static readonly ResourceManager _resourceManager
            = new ResourceManager("Harmony.Core.EF.Properties.HarmonyStrings", typeof(HarmonyStrings).GetTypeInfo().Assembly);


        /// <summary>
        ///     Attempted to update or delete an entity that does not exist in the store.
        /// </summary>
        public static string UpdateConcurrencyException
            => GetString("UpdateConcurrencyException");

        /// <summary>
        ///     Conflicts were detected for instance of entity type '{entityType}' on the concurrency token properties {properties}. Consider using 'DbContextOptionsBuilder.EnableSensitiveDataLogging' to see the conflicting values.
        /// </summary>
        public static string UpdateConcurrencyTokenException(object entityType, object properties)
            => string.Format(
                GetString("UpdateConcurrencyTokenException", nameof(entityType), nameof(properties)),
                entityType, properties);

        /// <summary>
        ///     Conflicts were detected for instance of entity type '{entityType}' with the key value '{keyValue}' on the concurrency token property values {conflictingValues}, with corresponding database values {databaseValues}.
        /// </summary>
        public static string UpdateConcurrencyTokenExceptionSensitive(object entityType, object keyValue, object conflictingValues, object databaseValues)
            => string.Format(
                GetString("UpdateConcurrencyTokenExceptionSensitive", nameof(entityType), nameof(keyValue), nameof(conflictingValues), nameof(databaseValues)),
                entityType, keyValue, conflictingValues, databaseValues);

        private static string GetString(string name, params string[] formatterNames)
        {
            var value = _resourceManager.GetString(name);
            for (var i = 0; i < formatterNames.Length; i++)
            {
                value = value.Replace("{" + formatterNames[i] + "}", "{" + i + "}");
            }

            return value;
        }
    }
}
